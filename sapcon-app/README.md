# Microsoft SAP Logs Connector - Limited Private Preview

Copyright (c) Microsoft Corporation.  This preview software is Microsoft Confidential, and is subject to your Non-Disclosure Agreement with Microsoft.  You may use this preview software internally and only in accordance with the Azure preview terms, located at [Preview terms][PreviewTerms].  Microsoft reserves all other rights



[Changelog]

## SAP Logs Continuous extraction Connector for Azure Sentinel


## Features
- Stateless and stateful connections for All SAP system Landscape
- Accessing ABAP and OS for Logs Acquisition

## Prerequisites

### SAP Backend Configuration

- Access to SAP instances can be provided by user/password (less secure) or a user with X509 certificate . 
- Access to sapcontrol can be provided by user/password or via pki cert please see [SAP Control Note][sapsrvauth]
- Import Change Requests which are available under [CR] folder
- Assign required authorizations for the ABAP backend user. [ABAP System Auth][ABAPBackendAuth]



## Installation
<!-- - First , Please follow instructions in : [Configuration Generator][ConfigGen] -->
- For onPrem installation Please follow : [OnPremise][OnPremDep]
- For Azure Deployment Please follow : [AzureSupport][AzureDep]


## Support

- Initialization process will retrieve data as of the 24H before initialization time.

- Please see backend logs compatability under [Backend Logs by Version][LOGS]

## Additional Documentation

[SAP Documentation - Support and Availability of the SAP NetWeaver RFC Library 7.50][rfcnote]

[SAP Documentation - XAL Interface Support][sapdocxal]

[SAP Documnetation - XBP Interface Support - XBP 3.0][sapdocxbp3]

[SAP Note 2173545 - CD: CHANGEDOCUMENT_READ_ALL][cdocnote]
[SAP Note 2502336 - CD: RSSCD100 - read only from archive, not from database][cdocnote2]

[SAP Note 2910263 - Unreleased XBP functions][xbp3note]

[SAP Note 927637 - Web service authentication in sapstartsrv as of Release 7.00][sapsrvauth]




[Template]: ./template
[CR]: ./CR
[sapcon]: ./sapcon
[Initsetup.sh]: ./initsetup.sh
[Initmenu.sh]: ./initmenu.sh
[Changelog]: ./docs/CHANGELOG.md
[LOGS]: ./docs/Logs.MD
[ABAPBackendAuth]: ./docs/ABAPBackendAuthorizations.MD
[config/filter]: ./sapcon/config/filter
[cdocnote]: https://launchpad.support.sap.com/#/notes/2173545
[cdocnote2]: https://launchpad.support.sap.com/#/notes/2502336
[rfcnote]: https://launchpad.support.sap.com/#/notes/2573790
[sapdocxal]: https://archive.sap.com/documents/docs/DOC-16459
[sapdocxbp3]: https://archive.sap.com/documents/docs/DOC-14201
[xbp3note]: https://launchpad.support.sap.com/#/notes/2910263
[sapctlws]: https://www.sap.com/documents/2016/09/0a40e60d-8b7c-0010-82c7-eda71af511fa.html
[sapsrvauth]: https://launchpad.support.sap.com/#/notes/927637
[OnPremDep]: ./docs/OnPrem_Deployment.md
[AzureDep]: ./docs/Azure_Deployment_Support.md
[ConfigGen]: ./docs/ConfigGen.md
[PreviewTerms]: https://azure.microsoft.com/en-us/support/legal/preview-supplemental-terms/
