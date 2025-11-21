@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Validation Header Root View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZAP_R_VAL
  as select from ZAP_I_VAL_HEAD
  composition [0..*] of ZAP_I_VAL_ITEM as _Items
  composition [0..*] of ZAP_I_VAL_LOG  as _Logs
{
  key ValUuid,
      ParentUuid,
      Status,
      InvoiceReference,
      InvoiceDate,
      VendorName,
      VendorVatNumber,
      PnpVatNumber,
      TotalVatInclusive,
      VatValue,
      PurchaseOrderNumber,
      CountryCode,
      VendorNumber,
      PoCcode,    
      PoType,
      @Semantics.user.createdBy: true
      LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      LocalCreatedAt,
      @Semantics.user.lastChangedBy: true
      LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      _Items,    // Make association public
      _Logs
}
