using System.Diagnostics;
using System.Net.Sockets;
using System.Security.Cryptography;
using System.Text.Json;
using Renci.SshNet;
using Renci.SshNet.Common;

namespace MinecraftVncControl;

internal static class Program
{
    [STAThread]
    private static void Main()
    {
        ApplicationConfiguration.Initialize();
        Application.Run(new MainForm());
    }
}

internal sealed class MainForm : Form
{
    private const string DefaultHost = "178.105.144.81";
    private const string DefaultUser = "vncguest";
    private const int DefaultSshPort = 22;
    private const int StatusIntervalMs = 5_000;

    private readonly TextBox hostBox = new() { Text = DefaultHost };
    private readonly NumericUpDown portBox = new() { Minimum = 1, Maximum = 65535, Value = DefaultSshPort };
    private readonly TextBox userBox = new() { Text = DefaultUser };
    private readonly TextBox passwordBox = new() { UseSystemPasswordChar = true };
    private readonly TextBox viewerBox = new();
    private readonly Button connectButton = new() { Text = "Verbinden" };
    private readonly Button disconnectButton = new() { Text = "Trennen", Enabled = false };
    private readonly Button openAllButton = new() { Text = "Alle VNC-Fenster öffnen", Enabled = false };
    private readonly Button refreshButton = new() { Text = "Status aktualisieren", Enabled = false };
    private readonly Label connectionLabel = new() { Text = "Nicht verbunden", AutoSize = true };
    private readonly Label messageLabel = new() { Text = "Passwort wird nur im Arbeitsspeicher gehalten und nie gespeichert.", AutoSize = true };
    private readonly System.Windows.Forms.Timer statusTimer = new() { Interval = StatusIntervalMs };
    private readonly SemaphoreSlim commandLock = new(1, 1);
    private readonly List<AccountPanel> accounts = new();

    private AppSettings settings;
    private SshClient? sshClient;
    private bool disconnecting;
    private int autoSellVncFailures;
    private DateTime autoSellRepairNotBeforeUtc = DateTime.MinValue;

    public MainForm()
    {
        settings = AppSettings.Load();
        Text = "Minecraft VNC Control";
        MinimumSize = new Size(780, 650);
        Size = new Size(900, 760);
        StartPosition = FormStartPosition.CenterScreen;
        Font = new Font("Segoe UI", 10F);

        hostBox.Text = string.IsNullOrWhiteSpace(settings.Host) ? DefaultHost : settings.Host;
        portBox.Value = settings.Port is >= 1 and <= 65535 ? settings.Port : DefaultSshPort;
        userBox.Text = string.IsNullOrWhiteSpace(settings.User) ? DefaultUser : settings.User;
        viewerBox.Text = FindViewer(settings.ViewerPath);

        BuildUi();
        connectButton.Click += async (_, _) => await ConnectAsync();
        disconnectButton.Click += (_, _) => Disconnect();
        openAllButton.Click += (_, _) => OpenAll();
        refreshButton.Click += async (_, _) => await RefreshStatusAsync(showErrors: true);
        statusTimer.Tick += async (_, _) => await RefreshStatusAsync(showErrors: false);
        FormClosing += (_, _) => Disconnect();
    }

    private void BuildUi()
    {
        var root = new TableLayoutPanel
        {
            Dock = DockStyle.Fill,
            Padding = new Padding(16),
            ColumnCount = 1,
            RowCount = 5,
            AutoScroll = true
        };
        root.RowStyles.Add(new RowStyle(SizeType.AutoSize));
        root.RowStyles.Add(new RowStyle(SizeType.AutoSize));
        root.RowStyles.Add(new RowStyle(SizeType.Percent, 100));
        root.RowStyles.Add(new RowStyle(SizeType.AutoSize));
        root.RowStyles.Add(new RowStyle(SizeType.AutoSize));

        var title = new Label
        {
            Text = "Minecraft VNC Control",
            Font = new Font(Font.FontFamily, 18F, FontStyle.Bold),
            AutoSize = true,
            Margin = new Padding(0, 0, 0, 12)
        };
        root.Controls.Add(title, 0, 0);

        var connection = new TableLayoutPanel
        {
            AutoSize = true,
            Dock = DockStyle.Top,
            ColumnCount = 8,
            Margin = new Padding(0, 0, 0, 14)
        };
        connection.ColumnStyles.Add(new ColumnStyle(SizeType.AutoSize));
        connection.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 45));
        connection.ColumnStyles.Add(new ColumnStyle(SizeType.AutoSize));
        connection.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 75));
        connection.ColumnStyles.Add(new ColumnStyle(SizeType.AutoSize));
        connection.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 25));
        connection.ColumnStyles.Add(new ColumnStyle(SizeType.AutoSize));
        connection.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 30));

        AddLabeledControl(connection, "Server", hostBox, 0);
        AddLabeledControl(connection, "Port", portBox, 2);
        AddLabeledControl(connection, "Benutzer", userBox, 4);
        AddLabeledControl(connection, "Passwort", passwordBox, 6);
        foreach (Control control in new Control[] { hostBox, portBox, userBox, passwordBox })
        {
            control.Dock = DockStyle.Fill;
            control.Margin = new Padding(5, 3, 12, 8);
        }
        root.Controls.Add(connection, 0, 1);

        var accountContainer = new FlowLayoutPanel
        {
            Dock = DockStyle.Fill,
            FlowDirection = FlowDirection.TopDown,
            WrapContents = false,
            AutoScroll = true
        };
        accounts.Add(CreateAccount("autosell", "AutoSell-Account", 15901, 5901));
        accounts.Add(CreateAccount("afk2", "Zweiter AFK-Account", 15902, 5902));
        accounts.Add(CreateAccount("afk3", "Dritter AFK-Account", 15903, 5903));
        accounts.Add(CreateAccount("afk4", "Vierter AFK-Account", 15904, 5904));
        accounts.Add(CreateAccount("autosell2", "Zweiter AutoSell-Account", 15905, 5905));
        foreach (var account in accounts)
        {
            accountContainer.Controls.Add(account.Container);
        }
        accountContainer.Resize += (_, _) =>
        {
            foreach (var account in accounts)
            {
                account.Container.Width = Math.Max(650, accountContainer.ClientSize.Width - 24);
            }
        };
        root.Controls.Add(accountContainer, 0, 2);

        var viewerRow = new TableLayoutPanel { AutoSize = true, Dock = DockStyle.Top, ColumnCount = 3 };
        viewerRow.ColumnStyles.Add(new ColumnStyle(SizeType.AutoSize));
        viewerRow.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));
        viewerRow.ColumnStyles.Add(new ColumnStyle(SizeType.AutoSize));
        viewerRow.Controls.Add(new Label { Text = "TigerVNC", AutoSize = true, Anchor = AnchorStyles.Left }, 0, 0);
        viewerBox.Dock = DockStyle.Fill;
        viewerBox.Margin = new Padding(8, 3, 8, 3);
        viewerRow.Controls.Add(viewerBox, 1, 0);
        var browseButton = new Button { Text = "Auswählen …", AutoSize = true };
        browseButton.Click += (_, _) => SelectViewer();
        viewerRow.Controls.Add(browseButton, 2, 0);
        root.Controls.Add(viewerRow, 0, 3);

        var footer = new FlowLayoutPanel
        {
            AutoSize = true,
            Dock = DockStyle.Bottom,
            FlowDirection = FlowDirection.LeftToRight,
            Padding = new Padding(0, 12, 0, 0)
        };
        footer.Controls.Add(connectButton);
        footer.Controls.Add(disconnectButton);
        footer.Controls.Add(openAllButton);
        footer.Controls.Add(refreshButton);
        footer.Controls.Add(connectionLabel);
        footer.Controls.Add(messageLabel);
        root.Controls.Add(footer, 0, 4);

        Controls.Add(root);
    }

    private static void AddLabeledControl(TableLayoutPanel panel, string label, Control control, int column)
    {
        panel.Controls.Add(new Label { Text = label, AutoSize = true, Anchor = AnchorStyles.Left }, column, 0);
        panel.Controls.Add(control, column + 1, 0);
    }

    private AccountPanel CreateAccount(string id, string title, int localPort, int remotePort)
    {
        var container = new Panel
        {
            Height = 112,
            Width = 800,
            BorderStyle = BorderStyle.FixedSingle,
            Margin = new Padding(0, 0, 0, 10)
        };
        var titleLabel = new Label
        {
            Text = title,
            Font = new Font(Font.FontFamily, 12F, FontStyle.Bold),
            AutoSize = true,
            Location = new Point(14, 12)
        };
        var statusLabel = new Label
        {
            Text = "Nicht verbunden",
            AutoSize = true,
            ForeColor = Color.DimGray,
            Location = new Point(14, 46)
        };
        var openButton = new Button
        {
            Text = "VNC öffnen",
            Enabled = false,
            Size = new Size(125, 34),
            Anchor = AnchorStyles.Top | AnchorStyles.Right,
            Location = new Point(container.Width - 282, 28)
        };
        var restartButton = new Button
        {
            Text = "Neu starten",
            Enabled = false,
            Size = new Size(125, 34),
            Anchor = AnchorStyles.Top | AnchorStyles.Right,
            Location = new Point(container.Width - 145, 28)
        };
        container.Controls.AddRange(new Control[] { titleLabel, statusLabel, openButton, restartButton });

        var account = new AccountPanel(id, title, localPort, remotePort, container, statusLabel, openButton, restartButton);
        openButton.Click += (_, _) => OpenViewer(account);
        restartButton.Click += async (_, _) => await RestartAsync(account);
        return account;
    }

    private async Task ConnectAsync()
    {
        if (sshClient?.IsConnected == true)
        {
            return;
        }
        if (string.IsNullOrWhiteSpace(hostBox.Text) || string.IsNullOrWhiteSpace(userBox.Text) || passwordBox.Text.Length == 0)
        {
            MessageBox.Show(this, "Server, Benutzer und Passwort müssen ausgefüllt sein.", "Fehlende Angaben",
                MessageBoxButtons.OK, MessageBoxIcon.Information);
            return;
        }

        SetConnectingUi(true);
        messageLabel.Text = "SSH-Verbindung wird aufgebaut …";
        try
        {
            var passwordAuth = new PasswordAuthenticationMethod(userBox.Text.Trim(), passwordBox.Text);
            var connectionInfo = new ConnectionInfo(
                hostBox.Text.Trim(),
                (int)portBox.Value,
                userBox.Text.Trim(),
                passwordAuth)
            {
                Timeout = TimeSpan.FromSeconds(15)
            };

            var client = new SshClient(connectionInfo) { KeepAliveInterval = TimeSpan.FromSeconds(15) };
            client.HostKeyReceived += (_, eventArgs) => VerifyHostKey(eventArgs);

            await Task.Run(() => client.Connect());
            sshClient = client;
            foreach (var account in accounts)
            {
                var forwarding = new ForwardedPortLocal(
                    "127.0.0.1",
                    (uint)account.LocalPort,
                    "127.0.0.1",
                    (uint)account.RemotePort);
                client.AddForwardedPort(forwarding);
                forwarding.Start();
                account.Forwarding = forwarding;
            }

            settings.Host = hostBox.Text.Trim();
            settings.Port = (int)portBox.Value;
            settings.User = userBox.Text.Trim();
            settings.ViewerPath = viewerBox.Text.Trim();
            settings.Save();

            disconnectButton.Enabled = true;
            openAllButton.Enabled = true;
            refreshButton.Enabled = true;
            foreach (var account in accounts)
            {
                account.OpenButton.Enabled = true;
                account.RestartButton.Enabled = true;
            }
            connectionLabel.Text = "Verbunden";
            connectionLabel.ForeColor = Color.ForestGreen;
            messageLabel.Text = "Sicherer Tunnel aktiv. Das Passwort wurde nicht gespeichert.";
            passwordBox.Clear();
            statusTimer.Start();
            await RefreshStatusAsync(showErrors: true);
        }
        catch (Exception ex)
        {
            Disconnect();
            MessageBox.Show(this, FriendlyError(ex), "Verbindung fehlgeschlagen",
                MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            SetConnectingUi(false);
        }
    }

    private void VerifyHostKey(HostKeyEventArgs eventArgs)
    {
        var fingerprint = "SHA256:" + Convert.ToBase64String(SHA256.HashData(eventArgs.HostKey)).TrimEnd('=');
        if (!string.IsNullOrWhiteSpace(settings.TrustedHostKey))
        {
            eventArgs.CanTrust = string.Equals(settings.TrustedHostKey, fingerprint, StringComparison.Ordinal);
            if (!eventArgs.CanTrust)
            {
                BeginInvoke(() => MessageBox.Show(this,
                    $"Der SSH-Schlüssel des Servers hat sich geändert.\n\nGespeichert: {settings.TrustedHostKey}\nAktuell: {fingerprint}\n\nNicht verbinden, bevor die Änderung geprüft wurde.",
                    "Sicherheitswarnung", MessageBoxButtons.OK, MessageBoxIcon.Stop));
            }
            return;
        }

        var result = (DialogResult)Invoke(() => MessageBox.Show(this,
            $"Erste Verbindung zu {hostBox.Text}.\n\nSSH-Fingerabdruck:\n{fingerprint}\n\nNur bestätigen, wenn dies dein Server ist.",
            "Server-Schlüssel bestätigen", MessageBoxButtons.YesNo, MessageBoxIcon.Question));
        eventArgs.CanTrust = result == DialogResult.Yes;
        if (eventArgs.CanTrust)
        {
            settings.TrustedHostKey = fingerprint;
            settings.Save();
        }
    }

    private async Task RefreshStatusAsync(bool showErrors)
    {
        if (sshClient?.IsConnected != true || disconnecting || !await commandLock.WaitAsync(0))
        {
            return;
        }

        try
        {
            var result = await Task.Run(() => RunCommand("vnc-control status"));
            var parsed = ParseStatus(result);
            foreach (var account in accounts)
            {
                if (!parsed.TryGetValue(account.Id, out var status))
                {
                    SetAccountStatus(account, "Status unbekannt", Color.DarkOrange);
                    continue;
                }

                if (status.Service == "active" && status.Vnc == "up")
                {
                    SetAccountStatus(account, "ONLINE – Client und VNC erreichbar", Color.ForestGreen);
                }
                else if (status.Service == "missing")
                {
                    SetAccountStatus(account, "Nicht eingerichtet", Color.Firebrick);
                }
                else if (status.Service == "active")
                {
                    SetAccountStatus(account, "Client läuft – VNC wird repariert", Color.DarkOrange);
                }
                else
                {
                    SetAccountStatus(account, $"Client {status.Service} – Neustart erforderlich", Color.Firebrick);
                }
            }

            var autoSell = parsed.GetValueOrDefault("autosell");
            var autoSellNeedsHelp = autoSell is not null
                                    && autoSell.Service != "missing"
                                    && (autoSell.Service != "active" || autoSell.Vnc != "up");
            if (autoSellNeedsHelp && DateTime.UtcNow >= autoSellRepairNotBeforeUtc)
            {
                autoSellVncFailures++;
                if (autoSellVncFailures >= 2)
                {
                    autoSellVncFailures = 0;
                    autoSellRepairNotBeforeUtc = DateTime.UtcNow.AddSeconds(90);
                    var action = autoSell!.Service == "active" ? "repair" : "restart";
                    await Task.Run(() => RunCommand($"vnc-control {action} autosell"));
                    messageLabel.Text = action == "repair"
                        ? "AutoSell-VNC wurde automatisch repariert."
                        : "Der gestoppte AutoSell-Client wurde automatisch neu gestartet.";
                }
            }
            else if (!autoSellNeedsHelp)
            {
                autoSellVncFailures = 0;
                autoSellRepairNotBeforeUtc = DateTime.MinValue;
            }
        }
        catch (Exception ex)
        {
            connectionLabel.Text = "Verbindungsfehler";
            connectionLabel.ForeColor = Color.Firebrick;
            if (showErrors)
            {
                MessageBox.Show(this, FriendlyError(ex), "Status konnte nicht gelesen werden",
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }
        finally
        {
            commandLock.Release();
        }
    }

    private async Task RestartAsync(AccountPanel account)
    {
        if (MessageBox.Show(this,
                $"{account.Title} wirklich neu starten?\nDie aktuelle Minecraft-Verbindung wird dabei kurz getrennt.",
                "Neustart bestätigen", MessageBoxButtons.YesNo, MessageBoxIcon.Question) != DialogResult.Yes)
        {
            return;
        }

        account.RestartButton.Enabled = false;
        messageLabel.Text = $"{account.Title} wird neu gestartet …";
        await commandLock.WaitAsync();
        try
        {
            var result = await Task.Run(() => RunCommand($"vnc-control restart {account.Id}"));
            messageLabel.Text = string.IsNullOrWhiteSpace(result) ? "Neustart wurde ausgelöst." : result.Trim();
            SetAccountStatus(account, "Startet …", Color.DarkOrange);
        }
        catch (Exception ex)
        {
            MessageBox.Show(this, FriendlyError(ex), "Neustart fehlgeschlagen",
                MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            commandLock.Release();
            account.RestartButton.Enabled = sshClient?.IsConnected == true;
        }

        await Task.Delay(3_000);
        await RefreshStatusAsync(showErrors: false);
    }

    private string RunCommand(string commandText)
    {
        var client = sshClient ?? throw new InvalidOperationException("Keine SSH-Verbindung vorhanden.");
        if (!client.IsConnected)
        {
            throw new SshConnectionException("Die SSH-Verbindung wurde getrennt.");
        }

        using var command = client.CreateCommand(commandText);
        command.CommandTimeout = TimeSpan.FromSeconds(30);
        var output = command.Execute();
        if (command.ExitStatus != 0)
        {
            throw new InvalidOperationException(string.IsNullOrWhiteSpace(command.Error)
                ? $"Serverbefehl fehlgeschlagen (Code {command.ExitStatus})."
                : command.Error.Trim());
        }
        return output;
    }

    private static Dictionary<string, RemoteStatus> ParseStatus(string output)
    {
        var result = new Dictionary<string, RemoteStatus>(StringComparer.OrdinalIgnoreCase);
        foreach (var line in output.Split('\n', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries))
        {
            var parts = line.Split('|');
            if (parts.Length >= 3)
            {
                result[parts[0]] = new RemoteStatus(parts[1], parts[2]);
            }
        }
        return result;
    }

    private void OpenAll()
    {
        foreach (var account in accounts)
        {
            OpenViewer(account);
        }
    }

    private void OpenViewer(AccountPanel account)
    {
        var viewer = viewerBox.Text.Trim();
        if (!File.Exists(viewer))
        {
            MessageBox.Show(this, "TigerVNC wurde nicht gefunden. Bitte unten über ‚Auswählen …‘ die Datei vncviewer.exe auswählen.",
                "TigerVNC fehlt", MessageBoxButtons.OK, MessageBoxIcon.Information);
            return;
        }
        if (!IsLocalPortOpen(account.LocalPort))
        {
            MessageBox.Show(this, "Der SSH-Tunnel ist noch nicht erreichbar. Bitte kurz warten und den Status aktualisieren.",
                "Tunnel nicht bereit", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            return;
        }

        settings.ViewerPath = viewer;
        settings.Save();
        Process.Start(new ProcessStartInfo
        {
            FileName = viewer,
            Arguments = $"127.0.0.1::{account.LocalPort}",
            UseShellExecute = true
        });
    }

    private static bool IsLocalPortOpen(int port)
    {
        try
        {
            using var client = new TcpClient();
            return client.ConnectAsync("127.0.0.1", port).Wait(TimeSpan.FromMilliseconds(700));
        }
        catch
        {
            return false;
        }
    }

    private void SelectViewer()
    {
        using var dialog = new OpenFileDialog
        {
            Filter = "TigerVNC Viewer (vncviewer.exe)|vncviewer.exe|Programme (*.exe)|*.exe",
            Title = "TigerVNC Viewer auswählen"
        };
        if (dialog.ShowDialog(this) == DialogResult.OK)
        {
            viewerBox.Text = dialog.FileName;
            settings.ViewerPath = dialog.FileName;
            settings.Save();
        }
    }

    private void Disconnect()
    {
        if (disconnecting)
        {
            return;
        }
        disconnecting = true;
        statusTimer.Stop();
        try
        {
            foreach (var account in accounts)
            {
                try { account.Forwarding?.Stop(); } catch { }
                account.Forwarding?.Dispose();
                account.Forwarding = null;
                account.OpenButton.Enabled = false;
                account.RestartButton.Enabled = false;
                SetAccountStatus(account, "Nicht verbunden", Color.DimGray);
            }
            try { sshClient?.Disconnect(); } catch { }
            sshClient?.Dispose();
            sshClient = null;
        }
        finally
        {
            disconnecting = false;
            connectButton.Enabled = true;
            disconnectButton.Enabled = false;
            openAllButton.Enabled = false;
            refreshButton.Enabled = false;
            hostBox.Enabled = true;
            portBox.Enabled = true;
            userBox.Enabled = true;
            passwordBox.Enabled = true;
            connectionLabel.Text = "Nicht verbunden";
            connectionLabel.ForeColor = Color.DimGray;
            messageLabel.Text = "Passwort wird nur im Arbeitsspeicher gehalten und nie gespeichert.";
        }
    }

    private void SetConnectingUi(bool connecting)
    {
        connectButton.Enabled = !connecting && sshClient?.IsConnected != true;
        hostBox.Enabled = !connecting && sshClient?.IsConnected != true;
        portBox.Enabled = !connecting && sshClient?.IsConnected != true;
        userBox.Enabled = !connecting && sshClient?.IsConnected != true;
        passwordBox.Enabled = !connecting && sshClient?.IsConnected != true;
    }

    private static void SetAccountStatus(AccountPanel account, string text, Color color)
    {
        account.StatusLabel.Text = text;
        account.StatusLabel.ForeColor = color;
    }

    private static string FindViewer(string configured)
    {
        var candidates = new[]
        {
            configured,
            Path.Combine(AppContext.BaseDirectory, "vncviewer.exe"),
            @"C:\Program Files\TigerVNC\vncviewer.exe",
            @"C:\Program Files (x86)\TigerVNC\vncviewer.exe"
        };
        return candidates.FirstOrDefault(path => !string.IsNullOrWhiteSpace(path) && File.Exists(path))
               ?? @"C:\Program Files\TigerVNC\vncviewer.exe";
    }

    private static string FriendlyError(Exception exception)
    {
        if (exception is SshAuthenticationException)
        {
            return "Anmeldung abgelehnt. Bitte das Passwort des Benutzers vncguest prüfen.";
        }
        if (exception is SocketException)
        {
            return "Der Server ist nicht erreichbar oder SSH-Port 22 ist blockiert.";
        }
        return exception.Message;
    }

    private sealed record RemoteStatus(string Service, string Vnc);

    private sealed class AccountPanel(
        string id,
        string title,
        int localPort,
        int remotePort,
        Panel container,
        Label statusLabel,
        Button openButton,
        Button restartButton)
    {
        public string Id { get; } = id;
        public string Title { get; } = title;
        public int LocalPort { get; } = localPort;
        public int RemotePort { get; } = remotePort;
        public Panel Container { get; } = container;
        public Label StatusLabel { get; } = statusLabel;
        public Button OpenButton { get; } = openButton;
        public Button RestartButton { get; } = restartButton;
        public ForwardedPortLocal? Forwarding { get; set; }
    }
}

internal sealed class AppSettings
{
    public string Host { get; set; } = "178.105.144.81";
    public int Port { get; set; } = 22;
    public string User { get; set; } = "vncguest";
    public string ViewerPath { get; set; } = "";
    public string TrustedHostKey { get; set; } = "";

    private static string SettingsPath => Path.Combine(
        Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
        "MinecraftVncControl",
        "settings.json");

    public static AppSettings Load()
    {
        try
        {
            return File.Exists(SettingsPath)
                ? JsonSerializer.Deserialize<AppSettings>(File.ReadAllText(SettingsPath)) ?? new AppSettings()
                : new AppSettings();
        }
        catch
        {
            return new AppSettings();
        }
    }

    public void Save()
    {
        var directory = Path.GetDirectoryName(SettingsPath)!;
        Directory.CreateDirectory(directory);
        File.WriteAllText(SettingsPath, JsonSerializer.Serialize(this, new JsonSerializerOptions { WriteIndented = true }));
    }
}
