Add-Type @"
    using System;
    using System.Runtime.InteropServices;

    public static class DisplayControl {
        [DllImport("user32.dll")]
        public static extern bool LockWorkStation();

        [DllImport("user32.dll")]
        public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);

        public const int HWND_BROADCAST = 0xffff;
        public const int WM_SYSCOMMAND = 0x0112;
        public const int SC_MONITORPOWER = 0xf170;

        public static void TurnOffMonitor() {
            SendMessage(HWND_BROADCAST, WM_SYSCOMMAND, SC_MONITORPOWER, 2);
        }

        public static void TurnOnMonitor() {
            SendMessage(HWND_BROADCAST, WM_SYSCOMMAND, SC_MONITORPOWER, -1);
        }
    }
"@

# Press 'O' to turn off the display, press 'P' to turn it back on and then exit after 2 seconds
while ($true) {
    if ([System.Console]::KeyAvailable) {
        $key = [System.Console]::ReadKey($true).Key
        if ($key -eq 'O') {
            [DisplayControl]::TurnOffMonitor()
            Write-Host "Display turned off."
        }
        elseif ($key -eq 'P') {
            [DisplayControl]::TurnOnMonitor()
            Write-Host "Display turned on. PowerShell is closing now."
            Start-Sleep -Seconds 1  # Wait for 1 seconds
            exit
        }
    }
    Start-Sleep -Milliseconds 100
}
