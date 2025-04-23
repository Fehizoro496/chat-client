const { app, BrowserWindow } = require('electron');

let mainWindow;

app.on('ready', () => {
    mainWindow = new BrowserWindow({
        width: 375, // Phone-like width
        height: 667, // Phone-like height
        resizable: false, // Prevent resizing
        webPreferences: {
            // ...existing code...
        }
    });

    mainWindow.loadURL('file://' + __dirname + '/index.html');
    // ...existing code...
});
