# Sami's Surface Automation Suite

A professional-grade, multi-architecture diagnostic and deployment toolkit developed for Microsoft Surface inventory management.

## The Challenge:
Refurbishing Surface tablets involves a complex 16-page SOP. Legacy ARM-based devices (**Surface RT**) operate in "Constrained Language Mode," which blocks modern automation, while early Intel-based devices (**Surface Pro 1/2**) often suffer from WMI communication failures when running modern Windows 10 LTSC.

## The Solution:
I developed a **Smart Dispatcher Architecture** that identifies the system architecture and automatically deploys the appropriate diagnostic environment.

### Key Features
- **Smart Dispatching:** Auto-detects OS Version (NT 6.3 vs 10.0) to choose between Legacy and Modern paths.
- **Hybrid Battery Logic:** Implements a `Try/Catch` fallback system. If modern CIM instances fail on older hardware, the suite reverts to legacy WMI calls to ensure 100% battery health reporting accuracy.
- **Hardware Audit:** Instantly captures CPU, RAM, Storage, OS, and Serial Numbers.
- **Automated User-Loop:** Scripts the transition from Audit Mode to OOBE and back, including a one-click **Return to Audit** tool.
- **Secure Wipe:** Automates the destruction of test profiles and clearing of Event Logs/Recycle Bin before final Sysprep shutdown.
- **SOP Documentation:** Includes a fully-responsive HTML technician guide.

## Repository Structure
- `Run_Audit.bat` - The "Smart" entry point.
- `Run_Return_To_Audit.bat` - Automates re-entry into the Administrator profile.
- `Run_Camera_Cleanup.bat` - Professional user-data destruction.
- `Run_Final_Ship.bat` - Final log-wipe and resale shutdown.
- `/Scripts` - The multi-architecture engine room (.ps1 and .bat).
- `/Reports` - (Auto-generated) Device-specific audit logs.


## Tools & Acknowledgements
This project was developed by **me**,  with technical assistance and logic-refinement from **Google AI Studio (Gemini)**. 

By leveraging AI-assisted development, I was able to:
- Rapidly prototype multi-architecture scripts.
- Debug complex "Constrained Language Mode" errors specific to Windows RT 8.1.
- Implement robust `Try/Catch` fallbacks for 12-year-old hardware namespaces.
- Ensure professional-grade technical documentation.

---
*Developed by Sami Alam | 2026*
