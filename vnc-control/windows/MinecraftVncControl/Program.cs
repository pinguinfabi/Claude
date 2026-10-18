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

internal static class Theme
{
    public static readonly Color Bg = Color.FromArgb(0x14, 0x16, 0x1B);
    public static readonly Color Header = Color.FromArgb(0x1A, 0x1D, 0x24);
    public static readonly Color Card = Color.FromArgb(0x1F, 0x23, 0x2B);
    public static readonly Color CardHover = Color.FromArgb(0x2B, 0x30, 0x3A);
    public static readonly Color Input = Color.FromArgb(0x2A, 0x2F, 0x39);
    public static readonly Color Text = Color.FromArgb(0xE8, 0xEA, 0xED);
    public static readonly Color Muted = Color.FromArgb(0x8B, 0x93, 0xA1);
    public static readonly Color Accent = Color.FromArgb(0x4C, 0x8D, 0xFF);
    public static readonly Color AccentHover = Color.FromArgb(0x6B, 0xA0, 0xFF);
    public static readonly Color Ok = Color.FromArgb(0x3D, 0xDC, 0x84);
    public static readonly Color Warn = Color.FromArgb(0xFF, 0xB0, 0x20);
    public static readonly Color Bad = Color.FromArgb(0xFF, 0x5C, 0x5C);
    public static readonly Color Idle = Color.FromArgb(0x6B, 0x72, 0x80);
}

/// <summary>Flacher Button im dunklen Stil.</summary>
internal sealed class FlatButton : Button
{
    private readonly bool primary;
    private bool hover;

    public FlatButton(string text, bool primary = false, int width = 132)
    {
        this.primary = primary;
        Text = text;
        FlatStyle = FlatStyle.Flat;
        FlatAppearance.BorderSize = 0;
        Cursor = Cursors.Hand;
        UseVisualStyleBackColor = false;
        Size = new Size(width, 36);
        Margin = new Padding(0, 0, 8, 0);
        ApplyColors();
    }

    protected override void OnEnabledChanged(EventArgs e)
    {
        base.OnEnabledChanged(e);
        ApplyColors();
    }

    protected override void OnMouseEnter(EventArgs e)
    {
        hover = true;
        ApplyColors();
        base.OnMouseEnter(e);
    }

    protected override void OnMouseLeave(EventArgs e)
    {
        hover = false;
        ApplyColors();
        base.OnMouseLeave(e);
    }

    private void ApplyColors()
    {
        if (!Enabled)
        {
            BackColor = Theme.Input;
            ForeColor = Theme.Muted;
            return;
        }
        BackColor = primary ? (hover ? Theme.AccentHover : Theme.Accent) : (hover ? Theme.CardHover : Theme.Input);
        ForeColor = primary ? Color.White : Theme.Text;
    }
}

internal sealed class MainForm : Form
{
    private const string DefaultHost = "173.249.38.29";
    private const string DefaultUser = "vncguest";
    private const int DefaultSshPort = 22;
    private const int StatusIntervalMs = 5_000;

    /// <summary>Feste Ziele auf dem Server (Id = Name in vnc-control, Port = VNC-Port auf dem Server).</summary>
    private static readonly TargetDef[] Targets =
    {
        new("afk1", "Prism 1", "", 5901),
        new("afk2", "Prism 2", "", 5902),
        new("j1", "Java-Bot 1", "", 0, true, 6101),
        new("j2", "Java-Bot 2", "", 0, true, 6102),
        new("j3", "Java-Bot 3", "", 0, true, 6103),
        new("j4", "Java-Bot 4", "", 0, true, 6104),
        new("j5", "Java-Bot 5", "", 0, true, 6105),
        new("b1", "Bedrock-Bot 1", "", 0, true, 6201),
        new("b2", "Bedrock-Bot 2", "", 0, true, 6202),
        new("b3", "Bedrock-Bot 3", "", 0, true, 6203),
        new("b4", "Bedrock-Bot 4", "", 0, true, 6204),
        new("b5", "Bedrock-Bot 5", "", 0, true, 6205)
    };


    private readonly TextBox hostBox = MakeTextBox();
    private readonly NumericUpDown portBox = new()
    {
        Minimum = 1, Maximum = 65535, Value = DefaultSshPort,
        BackColor = Theme.Input, ForeColor = Theme.Text, BorderStyle = BorderStyle.FixedSingle
    };
    private readonly TextBox userBox = MakeTextBox();
    private readonly TextBox passwordBox = MakeTextBox(password: true);
    private readonly TextBox viewerBox = MakeTextBox();
    private readonly FlatButton connectButton = new("Verbinden", primary: true, width: 150);
    private readonly FlatButton disconnectButton = new("Trennen") { Enabled = false };
    private readonly FlatButton openAllButton = new("Alle öffnen", primary: true) { Enabled = false };
    private readonly FlatButton refreshButton = new("Aktualisieren") { Enabled = false };
    private readonly Label connectionLabel = new() { AutoSize = true, ForeColor = Theme.Muted, Text = "● Nicht verbunden" };
    private readonly Label summaryLabel = new() { AutoSize = true, ForeColor = Theme.Muted, Text = "" };
    private readonly Label messageLabel = new()
    {
        AutoSize = true, ForeColor = Theme.Muted,
        Text = "Das Passwort wird nur im Arbeitsspeicher gehalten und nie gespeichert."
    };
    private readonly System.Windows.Forms.Timer statusTimer = new() { Interval = StatusIntervalMs };
    private readonly SemaphoreSlim commandLock = new(1, 1);
    private readonly List<AccountCard> accounts = new();
    private Control connectionPanel = null!;

    private AppSettings settings;
    private SshClient? sshClient;
    private bool disconnecting;

    public MainForm()
    {
        settings = AppSettings.Load();
        Text = "Minecraft VNC Control";
        MinimumSize = new Size(760, 640);
        Size = new Size(920, 900);
        StartPosition = FormStartPosition.CenterScreen;
        Font = new Font("Segoe UI", 10F);
        BackColor = Theme.Bg;
        ForeColor = Theme.Text;

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
        passwordBox.KeyDown += async (_, e) =>
        {
            if (e.KeyCode == Keys.Enter)
            {
                e.SuppressKeyPress = true;
                await ConnectAsync();
            }
        };
        FormClosing += (_, _) => Disconnect();
        UpdateSummary();
    }

    private static TextBox MakeTextBox(bool password = false) => new()
    {
        BackColor = Theme.Input,
        ForeColor = Theme.Text,
        BorderStyle = BorderStyle.FixedSingle,
        UseSystemPasswordChar = password
    };

    // ---------------------------------------------------------------- UI

    private void BuildUi()
    {
        var root = new TableLayoutPanel
        {
            Dock = DockStyle.Fill,
            ColumnCount = 1,
            RowCount = 5,
            BackColor = Theme.Bg
        };
        root.RowStyles.Add(new RowStyle(SizeType.AutoSize));     // Kopf
        root.RowStyles.Add(new RowStyle(SizeType.AutoSize));     // Verbindung
        root.RowStyles.Add(new RowStyle(SizeType.AutoSize));     // Werkzeugleiste
        root.RowStyles.Add(new RowStyle(SizeType.Percent, 100)); // Accounts
        root.RowStyles.Add(new RowStyle(SizeType.AutoSize));     // Fuß

        // Kopf
        var header = new TableLayoutPanel
        {
            Dock = DockStyle.Fill,
            AutoSize = true,
            ColumnCount = 2,
            BackColor = Theme.Header,
            Padding = new Padding(22, 16, 22, 16)
        };
        header.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));
        header.ColumnStyles.Add(new ColumnStyle(SizeType.AutoSize));
        var titleBox = new FlowLayoutPanel
        {
            AutoSize = true, FlowDirection = FlowDirection.TopDown, WrapContents = false, BackColor = Theme.Header
        };
        titleBox.Controls.Add(new Label
        {
            Text = "Minecraft VNC Control",
            Font = new Font(Font.FontFamily, 18F, FontStyle.Bold),
            ForeColor = Theme.Text,
            AutoSize = true,
            Margin = new Padding(0)
        });
        titleBox.Controls.Add(new Label
        {
            Text = "Prism-Clients und Chat-Bots steuern",
            ForeColor = Theme.Muted,
            AutoSize = true,
            Margin = new Padding(0, 2, 0, 0)
        });
        header.Controls.Add(titleBox, 0, 0);
        connectionLabel.Anchor = AnchorStyles.Right;
        connectionLabel.Font = new Font(Font.FontFamily, 10.5F, FontStyle.Bold);
        header.Controls.Add(connectionLabel, 1, 0);
        root.Controls.Add(header, 0, 0);

        // Verbindung
        var connection = new TableLayoutPanel
        {
            Dock = DockStyle.Fill,
            AutoSize = true,
            ColumnCount = 5,
            Padding = new Padding(22, 16, 22, 4),
            BackColor = Theme.Bg
        };
        connection.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 38));
        connection.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 90));
        connection.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 22));
        connection.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 28));
        connection.ColumnStyles.Add(new ColumnStyle(SizeType.AutoSize));
        AddField(connection, "Server", hostBox, 0);
        AddField(connection, "Port", portBox, 1);
        AddField(connection, "Benutzer", userBox, 2);
        AddField(connection, "Passwort", passwordBox, 3);
        connectButton.Anchor = AnchorStyles.Bottom;
        connectButton.Margin = new Padding(6, 0, 0, 8);
        connection.Controls.Add(connectButton, 4, 1);
        connectionPanel = connection;
        root.Controls.Add(connection, 0, 1);

        // Werkzeugleiste
        var toolbar = new FlowLayoutPanel
        {
            Dock = DockStyle.Fill,
            AutoSize = true,
            Padding = new Padding(22, 10, 22, 6),
            BackColor = Theme.Bg,
            WrapContents = false
        };
        toolbar.Controls.Add(openAllButton);
        toolbar.Controls.Add(refreshButton);
        toolbar.Controls.Add(disconnectButton);
        summaryLabel.Margin = new Padding(12, 9, 0, 0);
        toolbar.Controls.Add(summaryLabel);
        root.Controls.Add(toolbar, 0, 2);

        // Accounts
        var list = new FlowLayoutPanel
        {
            Dock = DockStyle.Fill,
            FlowDirection = FlowDirection.TopDown,
            WrapContents = false,
            AutoScroll = true,
            Padding = new Padding(22, 8, 14, 8),
            BackColor = Theme.Bg
        };
        foreach (var target in Targets)
        {
            if (target.Id == "afk1")
            {
                list.Controls.Add(SectionLabel("PRISM · JAVA-CLIENTS MIT MODS (VNC)"));
            }
            else if (target.Id == "j1")
            {
                list.Controls.Add(SectionLabel("JAVA · CHAT-BOTS (hugosmp.net)"));
            }
            else if (target.Id == "b1")
            {
                list.Controls.Add(SectionLabel("BEDROCK · CHAT-BOTS (hugosmp.net)"));
            }
            var card = new AccountCard(target, settings.LabelFor(target), target.Bot ? 10000 + target.ChatPort : 15000 + (target.Port % 100));
            card.OpenButton.Click += (_, _) => { if (card.Target.Bot) { OpenChat(card); } else { OpenViewer(card, silent: false); } };
            card.RestartButton.Click += async (_, _) => await RestartAsync(card);
            card.EditButton.Click += (_, _) => EditLabel(card);
            accounts.Add(card);
            list.Controls.Add(card);
        }
        void ResizeCards()
        {
            foreach (var card in accounts)
            {
                card.Width = Math.Max(560, list.ClientSize.Width - list.Padding.Horizontal);
            }
        }
        list.Resize += (_, _) => ResizeCards();
        ResizeCards();
        root.Controls.Add(list, 0, 3);

        // Fuß: Viewer-Pfad und Meldungen
        var footer = new TableLayoutPanel
        {
            Dock = DockStyle.Fill,
            AutoSize = true,
            ColumnCount = 3,
            RowCount = 2,
            Padding = new Padding(22, 8, 22, 14),
            BackColor = Theme.Header
        };
        footer.ColumnStyles.Add(new ColumnStyle(SizeType.AutoSize));
        footer.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));
        footer.ColumnStyles.Add(new ColumnStyle(SizeType.AutoSize));
        footer.Controls.Add(new Label { Text = "TigerVNC", AutoSize = true, ForeColor = Theme.Muted, Anchor = AnchorStyles.Left }, 0, 0);
        viewerBox.Dock = DockStyle.Fill;
        viewerBox.Margin = new Padding(8, 3, 8, 3);
        footer.Controls.Add(viewerBox, 1, 0);
        var browseButton = new FlatButton("Auswählen …", width: 120) { Margin = new Padding(0) };
        browseButton.Click += (_, _) => SelectViewer();
        footer.Controls.Add(browseButton, 2, 0);
        messageLabel.Margin = new Padding(0, 8, 0, 0);
        footer.Controls.Add(messageLabel, 0, 1);
        footer.SetColumnSpan(messageLabel, 3);
        root.Controls.Add(footer, 0, 4);

        Controls.Add(root);
    }

    private static Label SectionLabel(string text) => new()
    {
        Text = text,
        AutoSize = true,
        ForeColor = Theme.Muted,
        Font = new Font("Segoe UI", 9F, FontStyle.Bold),
        Margin = new Padding(2, 6, 0, 8)
    };

    private static void AddField(TableLayoutPanel panel, string label, Control control, int column)
    {
        panel.Controls.Add(new Label
        {
            Text = label, AutoSize = true, ForeColor = Theme.Muted, Margin = new Padding(6, 0, 0, 2)
        }, column, 0);
        control.Dock = DockStyle.Fill;
        control.Margin = new Padding(6, 0, 6, 8);
        panel.Controls.Add(control, column, 1);
    }

    // ---------------------------------------------------------------- Namen

    private void EditLabel(AccountCard card)
    {
        using var dialog = new RenameDialog(card.Target.Id, card.Label.Name, card.Label.Note);
        if (dialog.ShowDialog(this) != DialogResult.OK)
        {
            return;
        }

        var name = dialog.NameValue.Trim();
        card.SetLabel(new AccountLabel
        {
            Name = string.IsNullOrWhiteSpace(name) ? card.Target.DefaultName : name,
            Note = dialog.NoteValue.Trim()
        });
        settings.Names[card.Target.Id] = card.Label;
        settings.Save();
    }

    // ---------------------------------------------------------------- Verbindung

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
                    (uint)(account.Target.Bot ? account.Target.ChatPort : account.Target.Port));
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
                account.SetConnected(true);
            }
            connectionPanel.Visible = false;
            connectionLabel.Text = $"● Verbunden mit {settings.Host}";
            connectionLabel.ForeColor = Theme.Ok;
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
        var host = hostBox.Text.Trim();
        var fingerprint = "SHA256:" + Convert.ToBase64String(SHA256.HashData(eventArgs.HostKey)).TrimEnd('=');
        if (settings.TrustedHostKeys.TryGetValue(host, out var trusted) && !string.IsNullOrWhiteSpace(trusted))
        {
            eventArgs.CanTrust = string.Equals(trusted, fingerprint, StringComparison.Ordinal);
            if (!eventArgs.CanTrust)
            {
                BeginInvoke(() => MessageBox.Show(this,
                    $"Der SSH-Schlüssel des Servers hat sich geändert.\n\nGespeichert: {trusted}\nAktuell: {fingerprint}\n\nNicht verbinden, bevor die Änderung geprüft wurde.",
                    "Sicherheitswarnung", MessageBoxButtons.OK, MessageBoxIcon.Stop));
            }
            return;
        }

        var result = (DialogResult)Invoke(() => MessageBox.Show(this,
            $"Erste Verbindung zu {host}.\n\nSSH-Fingerabdruck:\n{fingerprint}\n\nNur bestätigen, wenn dies dein Server ist.",
            "Server-Schlüssel bestätigen", MessageBoxButtons.YesNo, MessageBoxIcon.Question));
        eventArgs.CanTrust = result == DialogResult.Yes;
        if (eventArgs.CanTrust)
        {
            settings.TrustedHostKeys[host] = fingerprint;
            settings.Save();
        }
    }

    // ---------------------------------------------------------------- Status

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
                if (!parsed.TryGetValue(account.Target.Id, out var status))
                {
                    account.SetStatus("Status unbekannt", Theme.Warn);
                    account.ServiceActive = false;
                    continue;
                }

                account.ServiceActive = status.Service == "active";
                if (account.Target.Bot)
                {
                    ApplyBotStatus(account, status);
                    continue;
                }
                switch (status.Service)
                {
                    case "active" when status.Vnc == "up":
                        account.SetStatus("Online – Client und VNC erreichbar", Theme.Ok);
                        break;
                    case "active":
                        account.SetStatus("Client läuft – VNC wird verbunden …", Theme.Warn);
                        break;
                    case "activating":
                        account.SetStatus("Startet …", Theme.Warn);
                        break;
                    case "missing":
                        account.SetStatus("Nicht eingerichtet", Theme.Bad);
                        break;
                    case "inactive":
                        account.SetStatus("Gestoppt – mit „Neu starten“ starten", Theme.Idle);
                        break;
                    default:
                        account.SetStatus($"Client {status.Service} – Neustart erforderlich", Theme.Bad);
                        break;
                }

                await AutoRepairAsync(account, status);
            }
            UpdateSummary();
        }
        catch (Exception ex)
        {
            connectionLabel.Text = "● Verbindungsfehler";
            connectionLabel.ForeColor = Theme.Bad;
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

    /// <summary>Chat-Bots (Java und Bedrock): Status = systemd-Dienst + Zustandsdatei des Bots (up / login / down).</summary>
    private static void ApplyBotStatus(AccountCard account, RemoteStatus status)
    {
        var id = account.Target.Id;
        if (status.Service == "missing")
        {
            account.SetStatus("Nicht eingerichtet", Theme.Bad);
        }
        else if (status.Vnc == "login")
        {
            account.SetStatus($"Login nötig – auf dem Server: bot-login {id}", Theme.Bad);
        }
        else if (status.Service == "active" && status.Vnc == "up")
        {
            account.SetStatus("Online – im Spiel", Theme.Ok);
        }
        else if (status.Service is "active" or "activating")
        {
            account.SetStatus("Verbindet / Relog läuft – Grund steht im Chat-Fenster", Theme.Warn);
        }
        else if (status.Service == "inactive")
        {
            account.SetStatus("Gestoppt – mit „Neu starten“ starten", Theme.Idle);
        }
        else
        {
            account.SetStatus($"Bot {status.Service} – Neustart erforderlich", Theme.Bad);
        }
    }

    /// <summary>Repariert nur die VNC-Brücke eines laufenden Clients; gestoppte Clients werden nie automatisch gestartet.</summary>
    private async Task AutoRepairAsync(AccountCard account, RemoteStatus status)
    {
        if (account.Target.Bot)
        {
            return;
        }
        var needsRepair = status.Service == "active" && status.Vnc != "up";
        if (!needsRepair)
        {
            account.VncFailures = 0;
            account.RepairNotBeforeUtc = DateTime.MinValue;
            return;
        }
        if (DateTime.UtcNow < account.RepairNotBeforeUtc)
        {
            return;
        }
        if (++account.VncFailures < 2)
        {
            return;
        }

        account.VncFailures = 0;
        account.RepairNotBeforeUtc = DateTime.UtcNow.AddSeconds(90);
        await Task.Run(() => RunCommand($"vnc-control repair {account.Target.Id}"));
        messageLabel.Text = $"VNC von „{account.Label.Name}“ wurde automatisch repariert.";
    }

    private void UpdateSummary()
    {
        var total = accounts.Count;
        var online = accounts.Count(a => a.IsOnline);
        summaryLabel.Text = sshClient?.IsConnected == true ? $"{online} von {total} online" : "";
    }

    private async Task RestartAsync(AccountCard account)
    {
        if (MessageBox.Show(this,
                $"„{account.Label.Name}“ ({account.Target.Id}) wirklich neu starten?\nDie aktuelle Minecraft-Verbindung wird dabei kurz getrennt.",
                "Neustart bestätigen", MessageBoxButtons.YesNo, MessageBoxIcon.Question) != DialogResult.Yes)
        {
            return;
        }

        account.RestartButton.Enabled = false;
        messageLabel.Text = $"„{account.Label.Name}“ wird neu gestartet …";
        await commandLock.WaitAsync();
        try
        {
            var result = await Task.Run(() => RunCommand($"vnc-control restart {account.Target.Id}"));
            messageLabel.Text = string.IsNullOrWhiteSpace(result) ? "Neustart wurde ausgelöst." : result.Trim();
            account.SetStatus("Startet …", Theme.Warn);
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

    // ---------------------------------------------------------------- Viewer

    private void OpenAll()
    {
        var opened = 0;
        foreach (var account in accounts.Where(a => a.ServiceActive && !a.Target.Bot))
        {
            if (OpenViewer(account, silent: true))
            {
                opened++;
            }
        }
        messageLabel.Text = opened == 0
            ? "Kein Account ist gerade online."
            : $"{opened} VNC-Fenster geöffnet.";
    }

    private readonly Dictionary<string, ChatForm> chats = new();

    private void OpenChat(AccountCard account)
    {
        if (chats.TryGetValue(account.Target.Id, out var existing) && !existing.IsDisposed)
        {
            existing.WindowState = FormWindowState.Normal;
            existing.Activate();
            return;
        }
        var form = new ChatForm($"{account.Label.Name} ({account.Target.Id})", account.LocalPort);
        chats[account.Target.Id] = form;
        form.Show(this);
    }

    private bool OpenViewer(AccountCard account, bool silent)
    {
        var viewer = viewerBox.Text.Trim();
        if (!File.Exists(viewer))
        {
            if (!silent)
            {
                MessageBox.Show(this, "TigerVNC wurde nicht gefunden. Bitte unten über ‚Auswählen …‘ die Datei vncviewer.exe auswählen.",
                    "TigerVNC fehlt", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            return false;
        }
        if (!IsLocalPortOpen(account.LocalPort))
        {
            if (!silent)
            {
                MessageBox.Show(this, "Der SSH-Tunnel ist noch nicht erreichbar. Bitte kurz warten und den Status aktualisieren.",
                    "Tunnel nicht bereit", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            return false;
        }

        settings.ViewerPath = viewer;
        settings.Save();
        Process.Start(new ProcessStartInfo
        {
            FileName = viewer,
            Arguments = $"127.0.0.1::{account.LocalPort}",
            UseShellExecute = true
        });
        return true;
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

    // ---------------------------------------------------------------- Trennen / UI-Zustand

    private void Disconnect()
    {
        if (disconnecting)
        {
            return;
        }
        disconnecting = true;
        statusTimer.Stop();
        foreach (var chat in chats.Values.ToList())
        {
            if (!chat.IsDisposed)
            {
                chat.Close();
            }
        }
        chats.Clear();
        try
        {
            foreach (var account in accounts)
            {
                try { account.Forwarding?.Stop(); } catch { }
                account.Forwarding?.Dispose();
                account.Forwarding = null;
                account.SetConnected(false);
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
            connectionPanel.Visible = true;
            connectionLabel.Text = "● Nicht verbunden";
            connectionLabel.ForeColor = Theme.Muted;
            messageLabel.Text = "Das Passwort wird nur im Arbeitsspeicher gehalten und nie gespeichert.";
            UpdateSummary();
        }
    }

    private void SetConnectingUi(bool connecting)
    {
        var free = !connecting && sshClient?.IsConnected != true;
        connectButton.Enabled = free;
        hostBox.Enabled = free;
        portBox.Enabled = free;
        userBox.Enabled = free;
        passwordBox.Enabled = free;
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
}

/// <summary>Chat-Fenster eines Bots: wie der Minecraft-Chat (lesen, schreiben, /befehle).</summary>
internal sealed class ChatForm : Form
{
    private static readonly System.Text.RegularExpressions.Regex ColorCodes = new("§.", System.Text.RegularExpressions.RegexOptions.Compiled);

    private readonly RichTextBox log = new()
    {
        ReadOnly = true, BorderStyle = BorderStyle.None, BackColor = Theme.Card, ForeColor = Theme.Text,
        Dock = DockStyle.Fill, Font = new Font("Consolas", 10F), DetectUrls = false
    };
    private readonly TextBox input = new()
    {
        BackColor = Theme.Input, ForeColor = Theme.Text, BorderStyle = BorderStyle.FixedSingle,
        Dock = DockStyle.Fill, MaxLength = 256, Margin = new Padding(0, 4, 8, 0)
    };
    private readonly FlatButton sendButton = new("Senden", primary: true, width: 100) { Margin = new Padding(0, 3, 0, 0) };
    private readonly Label statusLabel = new() { AutoSize = true, ForeColor = Theme.Muted, Text = "Verbinde …" };
    private readonly int localPort;
    private readonly CancellationTokenSource cts = new();
    private readonly object writeLock = new();
    private Stream? stream;

    public ChatForm(string title, int localPort)
    {
        this.localPort = localPort;
        Text = "Chat – " + title;
        Size = new Size(760, 520);
        MinimumSize = new Size(480, 320);
        StartPosition = FormStartPosition.CenterParent;
        BackColor = Theme.Bg;
        ForeColor = Theme.Text;
        Font = new Font("Segoe UI", 10F);

        var root = new TableLayoutPanel { Dock = DockStyle.Fill, ColumnCount = 1, RowCount = 3, Padding = new Padding(12) };
        root.RowStyles.Add(new RowStyle(SizeType.AutoSize));
        root.RowStyles.Add(new RowStyle(SizeType.Percent, 100));
        root.RowStyles.Add(new RowStyle(SizeType.AutoSize));
        root.Controls.Add(statusLabel, 0, 0);
        root.Controls.Add(log, 0, 1);
        var bottom = new TableLayoutPanel { Dock = DockStyle.Fill, AutoSize = true, ColumnCount = 2 };
        bottom.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));
        bottom.ColumnStyles.Add(new ColumnStyle(SizeType.AutoSize));
        bottom.Controls.Add(input, 0, 0);
        bottom.Controls.Add(sendButton, 1, 0);
        root.Controls.Add(bottom, 0, 2);
        Controls.Add(root);

        sendButton.Click += (_, _) => Send();
        input.KeyDown += (_, e) =>
        {
            if (e.KeyCode == Keys.Enter)
            {
                e.SuppressKeyPress = true;
                Send();
            }
        };
        Shown += (_, _) =>
        {
            input.Focus();
            _ = Task.Run(() => LoopAsync(cts.Token));
        };
        FormClosed += (_, _) => cts.Cancel();
    }

    private async Task LoopAsync(CancellationToken ct)
    {
        while (!ct.IsCancellationRequested)
        {
            try
            {
                using var tcp = new TcpClient();
                await tcp.ConnectAsync("127.0.0.1", localPort, ct);
                using var net = tcp.GetStream();
                lock (writeLock)
                {
                    stream = net;
                }
                using var reader = new StreamReader(net, System.Text.Encoding.UTF8);
                while (!ct.IsCancellationRequested)
                {
                    var line = await reader.ReadLineAsync(ct);
                    if (line is null)
                    {
                        break;
                    }
                    HandleLine(line);
                }
            }
            catch (OperationCanceledException)
            {
                break;
            }
            catch
            {
                // Tunnel oder Bot gerade nicht erreichbar -> weiter versuchen
            }

            lock (writeLock)
            {
                stream = null;
            }
            UiPost(() => statusLabel.Text = "● Getrennt – verbinde neu …");
            try
            {
                await Task.Delay(3000, ct);
            }
            catch (OperationCanceledException)
            {
                break;
            }
        }
    }

    private void HandleLine(string line)
    {
        try
        {
            using var doc = JsonDocument.Parse(line);
            var root = doc.RootElement;
            var type = root.GetProperty("t").GetString();
            switch (type)
            {
                case "hello":
                    UiPost(() =>
                    {
                        log.Clear();
                        statusLabel.Text = "● Verbunden – Bot: " + StateText(root.GetProperty("state").GetString());
                    });
                    break;
                case "state":
                    var state = root.GetProperty("state").GetString();
                    UiPost(() => statusLabel.Text = "● Verbunden – Bot: " + StateText(state));
                    break;
                case "chat":
                    var kind = root.GetProperty("kind").GetString();
                    var from = root.TryGetProperty("from", out var f) ? f.GetString() ?? "" : "";
                    var msg = ColorCodes.Replace(root.GetProperty("msg").GetString() ?? "", "");
                    var time = root.TryGetProperty("ts", out var ts)
                        ? DateTimeOffset.FromUnixTimeMilliseconds(ts.GetInt64()).LocalDateTime
                        : DateTime.Now;
                    var text = string.IsNullOrEmpty(from) ? msg : kind == "self" ? $"» {msg}" : $"<{from}> {msg}";
                    var color = kind == "self" ? Theme.Accent : string.IsNullOrEmpty(from) ? Theme.Muted : Theme.Text;
                    UiPost(() => Append($"[{time:HH:mm:ss}] {text}", color));
                    break;
                case "error":
                    var err = root.GetProperty("msg").GetString() ?? "Fehler";
                    UiPost(() => Append("! " + err, Theme.Bad));
                    break;
            }
        }
        catch
        {
            // unbekannte Zeile ignorieren
        }
    }

    private static string StateText(string? state) => state switch
    {
        "online" => "online",
        "connecting" => "verbindet / Relog läuft",
        "login" => "Login nötig",
        _ => state ?? "?"
    };

    private void Send()
    {
        var text = input.Text.Trim();
        if (text.Length == 0)
        {
            return;
        }
        byte[] data = System.Text.Encoding.UTF8.GetBytes(JsonSerializer.Serialize(new { t = "say", msg = text }) + "\n");
        try
        {
            lock (writeLock)
            {
                if (stream is null)
                {
                    throw new IOException("Nicht verbunden.");
                }
                stream.Write(data, 0, data.Length);
                stream.Flush();
            }
            input.Clear();
        }
        catch (Exception ex)
        {
            Append("! Senden fehlgeschlagen: " + ex.Message, Theme.Bad);
        }
    }

    private void Append(string line, Color color)
    {
        if (log.TextLength > 200_000)
        {
            log.Select(0, 50_000);
            log.SelectedText = "";
        }
        log.SelectionStart = log.TextLength;
        log.SelectionColor = color;
        log.AppendText(line + Environment.NewLine);
        log.SelectionColor = log.ForeColor;
        log.ScrollToCaret();
    }

    private void UiPost(Action action)
    {
        if (IsDisposed || !IsHandleCreated)
        {
            return;
        }
        try
        {
            BeginInvoke(action);
        }
        catch (InvalidOperationException)
        {
            // Fenster wird gerade geschlossen
        }
    }
}

internal sealed record TargetDef(string Id, string DefaultName, string DefaultNote, int Port, bool Bot = false, int ChatPort = 0);

/// <summary>Eine Account-Kachel mit Name, Notiz, Status und Knöpfen.</summary>
internal sealed class AccountCard : Panel
{
    private readonly Panel accent = new() { Dock = DockStyle.Left, Width = 6, BackColor = Theme.Idle };
    private readonly Label nameLabel = new();
    private readonly Label noteLabel = new();
    private readonly Label statusLabel = new();
    private readonly Label idLabel = new();

    public TargetDef Target { get; }
    public AccountLabel Label { get; private set; }
    public int LocalPort { get; }
    public FlatButton OpenButton { get; } = new("VNC öffnen", primary: true, width: 124) { Enabled = false };
    public FlatButton RestartButton { get; } = new("Neu starten", width: 124) { Enabled = false };
    public FlatButton EditButton { get; } = new("✎", width: 40);
    public ForwardedPortLocal? Forwarding { get; set; }
    public bool ServiceActive { get; set; }
    public int VncFailures { get; set; }
    public DateTime RepairNotBeforeUtc { get; set; } = DateTime.MinValue;
    public bool IsOnline { get; private set; }

    public AccountCard(TargetDef target, AccountLabel label, int localPort)
    {
        Target = target;
        Label = label;
        LocalPort = localPort;
        Height = 108;
        Width = 820;
        Margin = new Padding(0, 0, 0, 12);
        BackColor = Theme.Card;

        nameLabel.Font = new Font("Segoe UI", 14F, FontStyle.Bold);
        nameLabel.ForeColor = Theme.Text;
        nameLabel.AutoSize = true;
        nameLabel.Location = new Point(24, 12);
        noteLabel.ForeColor = Theme.Muted;
        noteLabel.AutoSize = true;
        noteLabel.Location = new Point(26, 44);
        statusLabel.AutoSize = true;
        statusLabel.Location = new Point(26, 72);
        statusLabel.Font = new Font("Segoe UI", 10F, FontStyle.Bold);
        idLabel.ForeColor = Theme.Muted;
        idLabel.Font = new Font("Segoe UI", 8.5F);
        idLabel.AutoSize = true;
        idLabel.Anchor = AnchorStyles.Top | AnchorStyles.Right;
        idLabel.Text = target.Bot ? $"{target.Id} · {(target.Id.StartsWith('j') ? "Java" : "Bedrock")}-Bot" : $"{target.Id} · Port {target.Port}";
        idLabel.Location = new Point(Width - 150, 12);

        var y = 36;
        EditButton.Anchor = AnchorStyles.Top | AnchorStyles.Right;
        EditButton.Location = new Point(Width - 40 - 16, y);
        RestartButton.Anchor = AnchorStyles.Top | AnchorStyles.Right;
        RestartButton.Location = new Point(EditButton.Left - 8 - 124, y);
        OpenButton.Anchor = AnchorStyles.Top | AnchorStyles.Right;
        OpenButton.Location = new Point(RestartButton.Left - 8 - 124, y);
        EditButton.Font = new Font("Segoe UI Symbol", 11F);
        OpenButton.Text = target.Bot ? "Chat" : "VNC öffnen";

        Controls.AddRange(new Control[] { accent, nameLabel, noteLabel, statusLabel, idLabel, OpenButton, RestartButton, EditButton });
        // idLabel liegt über den Knöpfen -> in die obere rechte Ecke schieben
        idLabel.Location = new Point(Width - 16 - idLabel.PreferredWidth, 10);

        SetLabel(label);
        SetStatus("Nicht verbunden", Theme.Idle);
    }

    public void SetLabel(AccountLabel label)
    {
        Label = label;
        nameLabel.Text = label.Name;
        noteLabel.Text = string.IsNullOrWhiteSpace(label.Note) ? "Keine Notiz – mit ✎ umbenennen" : label.Note;
    }

    public void SetConnected(bool connected)
    {
        OpenButton.Enabled = connected;
        RestartButton.Enabled = connected;
        if (!connected)
        {
            ServiceActive = false;
            VncFailures = 0;
            RepairNotBeforeUtc = DateTime.MinValue;
            SetStatus("Nicht verbunden", Theme.Idle);
        }
    }

    public void SetStatus(string text, Color color)
    {
        statusLabel.Text = "● " + text;
        statusLabel.ForeColor = color;
        accent.BackColor = color;
        IsOnline = color == Theme.Ok;
    }
}

/// <summary>Dialog zum Umbenennen eines Accounts.</summary>
internal sealed class RenameDialog : Form
{
    private readonly TextBox nameBox = new() { MaxLength = 40 };
    private readonly TextBox noteBox = new() { MaxLength = 80 };

    public string NameValue => nameBox.Text;
    public string NoteValue => noteBox.Text;

    public RenameDialog(string id, string name, string note)
    {
        Text = $"Account umbenennen ({id})";
        FormBorderStyle = FormBorderStyle.FixedDialog;
        MaximizeBox = false;
        MinimizeBox = false;
        StartPosition = FormStartPosition.CenterParent;
        ClientSize = new Size(440, 210);
        BackColor = Theme.Bg;
        ForeColor = Theme.Text;
        Font = new Font("Segoe UI", 10F);

        foreach (var box in new[] { nameBox, noteBox })
        {
            box.BackColor = Theme.Input;
            box.ForeColor = Theme.Text;
            box.BorderStyle = BorderStyle.FixedSingle;
        }
        nameBox.Text = name;
        noteBox.Text = note;

        Controls.Add(new Label { Text = "Name (z. B. Crafter, Farmer 1)", AutoSize = true, ForeColor = Theme.Muted, Location = new Point(20, 16) });
        nameBox.SetBounds(20, 40, 400, 28);
        Controls.Add(nameBox);
        Controls.Add(new Label { Text = "Notiz (optional, z. B. Aufgabe oder Spielername)", AutoSize = true, ForeColor = Theme.Muted, Location = new Point(20, 82) });
        noteBox.SetBounds(20, 106, 400, 28);
        Controls.Add(noteBox);

        var ok = new FlatButton("Speichern", primary: true, width: 120) { DialogResult = DialogResult.OK, Location = new Point(190, 156) };
        var cancel = new FlatButton("Abbrechen", width: 110) { DialogResult = DialogResult.Cancel, Location = new Point(316, 156) };
        Controls.Add(ok);
        Controls.Add(cancel);
        AcceptButton = ok;
        CancelButton = cancel;
    }
}

internal sealed class AccountLabel
{
    public string Name { get; set; } = "";
    public string Note { get; set; } = "";
}

internal sealed class AppSettings
{
    public string Host { get; set; } = "173.249.38.29";
    public int Port { get; set; } = 22;
    public string User { get; set; } = "vncguest";
    public string ViewerPath { get; set; } = "";
    public Dictionary<string, string> TrustedHostKeys { get; set; } = new();
    public Dictionary<string, AccountLabel> Names { get; set; } = new();

    private static string SettingsPath => Path.Combine(
        Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
        "MinecraftVncControl",
        "settings.json");

    public AccountLabel LabelFor(TargetDef target) =>
        Names.TryGetValue(target.Id, out var label) && !string.IsNullOrWhiteSpace(label.Name)
            ? label
            : new AccountLabel { Name = target.DefaultName, Note = target.DefaultNote };

    public static AppSettings Load()
    {
        try
        {
            var loaded = File.Exists(SettingsPath)
                ? JsonSerializer.Deserialize<AppSettings>(File.ReadAllText(SettingsPath)) ?? new AppSettings()
                : new AppSettings();
            loaded.TrustedHostKeys ??= new();
            loaded.Names ??= new();
            // Der alte Server wurde abgelöst: gespeicherte alte Adresse automatisch durch die neue ersetzen.
            if (loaded.Host == "178.105.144.81")
            {
                loaded.Host = "173.249.38.29";
            }
            return loaded;
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
