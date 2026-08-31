// Plasma Scripting API layout for the top panel.
// Portable across screen/monitor layouts (doesn't hardcode containment or
// screen IDs) so it works the same on both the laptop and the desktop.
//
// Apply with: qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$(cat ~/.config/plasma-panel-layout.js)"

var allPanels = panels();
for (var i = 0; i < allPanels.length; i++) {
    allPanels[i].remove();
}

var panel = new Panel;
panel.location = 'top';

var widgets = [
    'org.kde.plasma.systemtray',
    'org.kde.plasma.digitalclock',
    'org.kde.plasma.systemmonitor.cpucore',
    'org.kde.plasma.systemmonitor',
    'org.kde.plasma.powerusage',
    'org.kde.plasma.systemmonitor.memory',
    'org.kde.plasma.panelspacer',
    'com.github.zren.commandoutput'
];

for (var i = 0; i < widgets.length; i++) {
    panel.addWidget(widgets[i]);
}
