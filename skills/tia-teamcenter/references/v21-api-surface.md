# V21 API Reference: Siemens.Engineering.TeamcenterGateway

## 🛠️ Siemens.Engineering.TeamcenterGateway.DatasetType
>
> TcGateway project/library dataset type.

## 🛠️ Siemens.Engineering.TeamcenterGateway.ErrorCallback
>
> Delegate to handle error which are raised during API invocation/actions.

## 🛠️ Siemens.Engineering.TeamcenterGateway.ItemDetails
>
> Item details type for setting standard properties on TIA project/global library.

- 🔧 `Comment`: The comments entered shall be defaulted to the new Revision and also to the Dataset.
- 🔧 `ItemId`: ItemId of Project/Library in Teamcenter.
- 🔧 `ItemName`: Item name of Project/Library in Teamcenter.
- 🔧 `RevisionId`: RevisionId of Project/Library in Teamcenter.
- 🔧 `TeamcenterFolder`: Teamcenter folder where this new item shall be created.
- 🔧 `TeamcenterItemType`: Teamcenter item type.(e.g. TIA project or any of its subtype, TIA Library or any of its subtype)
- 🔧 `TeamcenterProject`: Teamcenter Project(s) where this new created item will belong to.

## 🛠️ Siemens.Engineering.TeamcenterGateway.ItemDetailsDelegate
>
> Delegate for setting standard properties for item creation in Teamcenter on TIA project/global library.

## 🛠️ Siemens.Engineering.TeamcenterGateway.ItemInfo
>
> TcGateway item information of project/Global library saved in Teamcenter.

- 🔧 `ItemId`: ItemId of Project/Library in Teamcenter.
- 🔧 `ItemName`: Item name of Project/Library in Teamcenter.
- 🔧 `ItemType`: Item type of Project/Library in Teamcenter.
- 🔧 `RevisionId`: RevisionId of Project/Library in Teamcenter.

## 🛠️ Siemens.Engineering.TeamcenterGateway.ItemType
>
> TcGateway project/library item type.

## 🛠️ Siemens.Engineering.TeamcenterGateway.ListOfValuesUsageType
>
> Types for LOV usage (Exhaustive, Suggestive and Range)

## 🛠️ Siemens.Engineering.TeamcenterGateway.LocalCacheOption
>
> TcGateway LocalCacheOption to overwrite TIA project/ Global library in TC cache.

## 🛠️ Siemens.Engineering.TeamcenterGateway.MappedCustomAttributeType
>
> Supported data types for custom attributes on Teamcenter types and subtypes.

## 🛠️ Siemens.Engineering.TeamcenterGateway.RevisionDetails
>
> Revision details type for setting standard properties on TIA project/global library.

- 🔧 `Comment`: The comments entered shall be defaulted to the new Revision and also to the Dataset.
- 🔧 `RevisionId`: RevisionId of Project / Global Library in Teamcenter.

## 🛠️ Siemens.Engineering.TeamcenterGateway.RevisionDetailsDelegate
>
> Delegate for setting standard properties for revision creation in Teamcenter on TIA project/global library.

## 🛠️ Siemens.Engineering.TeamcenterGateway.SearchResult
>
> Represents TIA object&apos;s ItemId and List of RevisionId in Teamcenter.

- 🔧 `ItemId`: ItemId of the TIA object item in Teamcenter.
- 🔧 `RevisionId`: RevisonIds of the TIA object item in Teamcenter.

## 🛠️ Siemens.Engineering.TeamcenterGateway.TcGatewayConnectionInfo
>
> Response returned on successfull connection to Teamcenter. Client applications have to safegaurd the TcGatewayConnectionInfo as all other workflow related API calls require TcGatewayConnectionInfo as input parameter.

- 🔧 `Group`: Teamcenter user&apos;s group.
- 🔧 `Role`: Teamcenter user&apos;s role.
- 🔧 `SessionToken`: Session token of active connection to Teamcenter.

## 🛠️ Siemens.Engineering.TeamcenterGateway.TcGatewayException
>
> This exception indicates that exception occured during execution of TcGateway-Openness API call

- 📦 `#ctor`: Initializes a new instance of the <see cref="T:Siemens.Engineering.TeamcenterGateway.TcGatewayException"/> class.
- 📦 `#ctor(System.String)`: Initializes a new instance of the <see cref="T:Siemens.Engineering.TeamcenterGateway.TcGatewayException"/> class.
- 📦 `#ctor(System.String,System.Exception)`: Initializes a new instance of the <see cref="T:Siemens.Engineering.TeamcenterGateway.TcGatewayException"/> class.
- 📦 `#ctor(System.String,System.String[])`: Initializes a new instance of the <see cref="T:Siemens.Engineering.TeamcenterGateway.TcGatewayException"/> class.
- 📦 `#ctor(System.Runtime.Serialization.SerializationInfo,System.Runtime.Serialization.StreamingContext)`: Initializes a new instance of the <see cref="T:Siemens.Engineering.TeamcenterGateway.TcGatewayException"/> class with serialized data.
- 📦 `GetObjectData(System.Runtime.Serialization.SerializationInfo,System.Runtime.Serialization.StreamingContext)`: When overridden in a derived class, sets the <see cref="T:System.Runtime.Serialization.SerializationInfo"/>B with information about the exception.

## 🛠️ Siemens.Engineering.TeamcenterGateway.TcGatewayLockProvider
>
> Provides TcGateway dataset lock services.

- 📦 `CancelCheckoutDataset(Siemens.Engineering.TeamcenterGateway.TcGatewayConnectionInfo,System.String,System.String,Siemens.Engineering.TeamcenterGateway.DatasetType,System.String)`: Checkout on dataset is cancelled, no implicit action of discarding changes is performed on project/library.
- 📦 `CheckinDataset(Siemens.Engineering.TeamcenterGateway.TcGatewayConnectionInfo,System.String,System.String,Siemens.Engineering.TeamcenterGateway.DatasetType,System.String)`: Check-in TIA project/Library dataset saved in Teamcenter.
- 📦 `CheckoutDataset(Siemens.Engineering.TeamcenterGateway.TcGatewayConnectionInfo,System.String,System.String,Siemens.Engineering.TeamcenterGateway.DatasetType,System.String)`: Checkout TIA project/Library dataset saved in Teamcenter.

## 🛠️ Siemens.Engineering.TeamcenterGateway.TcGatewaySearchAndDownloadProvider
>
> Search and downloads TIA Portal project/ global library from Teamcenter.

- 📦 `Download(Siemens.Engineering.TeamcenterGateway.TcGatewayConnectionInfo,System.String,System.String,Siemens.Engineering.TeamcenterGateway.ItemType,Siemens.Engineering.TeamcenterGateway.LocalCacheOption)`: Download the TIA Object(Project/ Library) from Teamcenter and store it in TcCache.
- 📦 `Search(Siemens.Engineering.TeamcenterGateway.TcGatewayConnectionInfo,Siemens.Engineering.TeamcenterGateway.ItemType,System.String,System.String,System.String,System.String)`: Search TIA Object (Project / Global library) from Teamcenter that only return list of ItemId with related list of RevisionId based on the search query.If no search results are found in Teamcenter an empty list is returned.

## 🛠️ Siemens.Engineering.TeamcenterGateway.TcGatewayWorkflowProvider
>
> TcGateway workflow service provider to save project/library in Teamcenter.

- 📦 `GetTeamcenterCustomAttributes(Siemens.Engineering.TeamcenterGateway.TcGatewayConnectionInfo,System.String)`: Gets all custom attributes on TIA project/global library itemType/subType mapped in Teamcenter.
- 📦 `Save(Siemens.Engineering.TeamcenterGateway.TcGatewayConnectionInfo,Siemens.Engineering.TeamcenterGateway.LocalCacheOption)`: Save TIA project/Global library to Teamcenter.
- 📦 `SaveAsNewItem(Siemens.Engineering.TeamcenterGateway.TcGatewayConnectionInfo,Siemens.Engineering.TeamcenterGateway.ItemDetailsDelegate,System.Collections.Generic.IEnumerable{Siemens.Engineering.TeamcenterGateway.TeamcenterProperty})`: Save TIA project/global library as a new item in Teamcenter. Custom attributes parameter is optional.
- 📦 `SaveAsNewItemWithProxyObject(Siemens.Engineering.TeamcenterGateway.TcGatewayConnectionInfo,Siemens.Engineering.TeamcenterGateway.ItemDetailsDelegate,System.Collections.Generic.IEnumerable{Siemens.Engineering.TeamcenterGateway.TeamcenterProperty})`: Save TIA project/global library as a new item in Teamcenter with proxy objects. Custom attributes parameter is optional. If custom attributes are required during item creation it can be fetched using GetTeamcenterCustomAttributes API, if custom attributes are not required during item creation pass null.
- 📦 `SaveAsNewRevision(Siemens.Engineering.TeamcenterGateway.TcGatewayConnectionInfo,Siemens.Engineering.TeamcenterGateway.RevisionDetailsDelegate,System.Collections.Generic.IEnumerable{Siemens.Engineering.TeamcenterGateway.TeamcenterProperty})`: Save TIA project / Global library as a new revision in Teamcenter. Custom attributes parameter is optional.
- 📦 `SaveAsNewRevisionWithProxyObject(Siemens.Engineering.TeamcenterGateway.TcGatewayConnectionInfo,Siemens.Engineering.TeamcenterGateway.RevisionDetailsDelegate,System.Collections.Generic.IEnumerable{Siemens.Engineering.TeamcenterGateway.TeamcenterProperty})`: Save TIA project / Global library as a new revision in Teamcenterwith proxy objects. Custom attributes parameter is optional. If custom attributes are required during item revision creation it can be fetched using GetTeamcenterCustomAttributes API, if custom attributes are not required during item creation pass null.
- 📦 `SaveToItem(Siemens.Engineering.TeamcenterGateway.TcGatewayConnectionInfo,System.String,System.String,Siemens.Engineering.TeamcenterGateway.LocalCacheOption)`: Save TIA Project / Global library to an existing item/revision in Teamcenter.
- 📦 `SaveToItemWithProxyObject(Siemens.Engineering.TeamcenterGateway.TcGatewayConnectionInfo,System.String,System.String,Siemens.Engineering.TeamcenterGateway.LocalCacheOption)`: Save TIA Project / Global library to an existing item/revision in Teamcenter with proxy objects.
- 📦 `SaveWithProxyObject(Siemens.Engineering.TeamcenterGateway.TcGatewayConnectionInfo,Siemens.Engineering.TeamcenterGateway.LocalCacheOption)`: Save TIA project/ Global library to Teamcenter with proxy objects(e.g. Plc, Program blocks, UDTs and supported types).

## 🛠️ Siemens.Engineering.TeamcenterGateway.TcPropertyListOfValueInfo
>
> Teamcenter property list of values information.

- 🔧 `LovUsageType`: List of values usage type (Exhaustive, Suggestive and Range)
- 🔧 `LowerLimit`: Lower limit of LOV.
- 🔧 `UpperLimit`: Upper limit of LOV.
- 🔧 `Values`: List of values.

## 🛠️ Siemens.Engineering.TeamcenterGateway.TeamcenterConnectionProvider
>
> Connection Provider service for connection and disconnection of TIA Portal with Teamcenter server.

- 📦 `Connect(System.String,System.Security.SecureString,System.String,System.String,System.String,System.String)`: Connect to Teamcenter using http/https protocol. Returns TcGatewayConnectionInfo.
- 📦 `ConnectSSO(System.String,System.String,System.String,System.String)`: Connect to Teamcenter using Single Sign On and PKI card. Returns TcGatewayConnectionInfo.
- 📦 `Disconnect(Siemens.Engineering.TeamcenterGateway.TcGatewayConnectionInfo)`: Disconnect from Teamcenter server.

## 🛠️ Siemens.Engineering.TeamcenterGateway.TeamcenterProperty
>
> Teamcenter custom property for item or revision.

- 🔧 `DataType`: Teamcenter custom property data type.
- 🔧 `DefaultValue`: Value of the attribute
- 🔧 `IsReadOnly`: Teamcenter custom property readonly attribute field
- 🔧 `IsRequired`: Teamcenter custom property mandatory attribute field
- 🔧 `ListOfValueInfo`: ListofValue(LOV) info of Teamcenter custom property.If ListofValue(LOV) info is not available on Teamcenter custom property it is null.
- 🔧 `LowerBound`: Lower bound for the attribute
- 🔧 `MappingLevel`: Level of context at which the attributes are mapped. The level can be 0-Item, 1-ItemMaster, 2-ItemRevision and 3-ItemRevisionMaster
- 🔧 `MaxFieldLength`: Maximum field length for string values
- 🔧 `Name`: Teamcenter custom property name.
- 🔧 `UpperBound`: Upper bound for the attribute
- 📦 `SetValue(System.String,Siemens.Engineering.TeamcenterGateway.ErrorCallback)`: Set Teamcenter property value.
