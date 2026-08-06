# Minimal working skeleton — Project-Tree Context Menu Add-In

A complete, compilable starting point for a project-tree context menu Add-In that operates
on PLC devices. Replace `MyAddIn` / `MyNamespace` with your actual names.

**`MyAddInProvider.cs`** — registers the Add-In with TIA Portal:

```csharp
using System.Collections.Generic;
using Siemens.Engineering;
using Siemens.Engineering.AddIn;
using Siemens.Engineering.AddIn.Menu;

namespace MyNamespace
{
    public class MyAddInProvider : ProjectTreeAddInProvider
    {
        private readonly TiaPortal m_TiaPortal;

        public MyAddInProvider(TiaPortal tiaPortal)
        {
            m_TiaPortal = tiaPortal;
        }

        protected override IEnumerable<ContextMenuAddIn> GetContextMenuAddIns()
        {
            yield return new MyContextMenuAddIn(m_TiaPortal);
        }
    }
}
```

**`MyContextMenuAddIn.cs`** — implements the menu item and its logic:

```csharp
using System;
using System.Collections.Generic;
using Siemens.Engineering;
using Siemens.Engineering.AddIn;
using Siemens.Engineering.AddIn.Menu;
using Siemens.Engineering.HW;
using Siemens.Engineering.HW.Features;
using Siemens.Engineering.SW;
using Siemens.Engineering.SW.Blocks;

namespace MyNamespace
{
    public class MyContextMenuAddIn : ContextMenuAddIn
    {
        private readonly TiaPortal m_TiaPortal;
        private const string DisplayName = "My Add-In";

        public MyContextMenuAddIn(TiaPortal tiaPortal) : base(DisplayName)
        {
            m_TiaPortal = tiaPortal;
        }

        protected override void BuildContextMenuItems(ContextMenuAddInRoot root)
        {
            // IEngineeringObject matches any project tree node.
            // Status callback must make no COM calls — return Enabled immediately.
            root.Items.AddActionItem<IEngineeringObject>(
                "Run My Add-In...", OnRun, _ => MenuStatus.Enabled);
        }

        // ── Action callback — COM access works here ──────────────────────────

        private void OnRun(MenuSelectionProvider<IEngineeringObject> provider)
        {
            var msgBox = m_TiaPortal.GetService<MessageBoxProvider>();

            foreach (IEngineeringObject obj in provider.GetSelection())
            {
                // Resolve PlcSoftware from whatever type was right-clicked
                PlcSoftware plcSoftware = null;
                string deviceName = "Unknown";

                if (obj is PlcSoftware sw)
                {
                    plcSoftware = sw;
                    deviceName = sw.Name;
                }
                else if (obj is Device device)
                {
                    plcSoftware = GetPlcSoftware(device);
                    deviceName = device.Name;
                }
                else if (obj is DeviceItem item)
                {
                    plcSoftware = item.GetService<SoftwareContainer>()?.Software as PlcSoftware;
                    deviceName = item.Name;
                }

                if (plcSoftware == null)
                {
                    msgBox?.ShowNotification(NotificationIcon.Warning, DisplayName,
                        $"No PLC software found. (Type: {obj.GetType().Name})");
                    return;
                }

                var collected = new List<string>();
                try
                {
                    CollectData(plcSoftware, collected);

                    // Keep interaction within this Add-In execution.
                    msgBox?.ShowNotification(
                        NotificationIcon.Information,
                        $"{DisplayName} — {deviceName}",
                        $"Found {collected.Count} blocks.",
                        string.Join(Environment.NewLine, collected));
                }
                catch (Exception ex)
                {
                    msgBox?.ShowNotification(NotificationIcon.Error, DisplayName,
                        $"Collection failed: {ex.Message}");
                    return;
                }

                break; // handle first selected item only
            }
        }

        // ── TIA Portal API helpers ───────────────────────────────────────────

        private static PlcSoftware GetPlcSoftware(Device device)
        {
            foreach (DeviceItem item in device.DeviceItems)
            {
                var sw = item.GetService<SoftwareContainer>()?.Software as PlcSoftware;
                if (sw != null) return sw;

                // Recurse — PLCs inside racks have nested DeviceItems
                sw = GetPlcSoftwareFromItems(item.DeviceItems);
                if (sw != null) return sw;
            }
            return null;
        }

        private static PlcSoftware GetPlcSoftwareFromItems(DeviceItemComposition items)
        {
            foreach (DeviceItem item in items)
            {
                var sw = item.GetService<SoftwareContainer>()?.Software as PlcSoftware;
                if (sw != null) return sw;
                sw = GetPlcSoftwareFromItems(item.DeviceItems);
                if (sw != null) return sw;
            }
            return null;
        }

        // ── Data collection — runs on TIA Portal thread ──────────────────────

        private static void CollectData(PlcSoftware plcSoftware, List<string> output)
        {
            // Replace with your actual data collection logic.
            // All TIA Portal API calls must happen here, not in the dialog.
            foreach (PlcBlock block in plcSoftware.BlockGroup.Blocks)
                output.Add($"{block.Name} [{block.GetType().Name}]");
        }
    }
}
```
