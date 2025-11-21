@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'OCR Invoice Header Root View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZAP_R_OCR
  as select from ZAP_I_OCR_HEAD
  composition [0..*] of ZAP_I_OCR_ITEM as _Items
  composition [0..*] of ZAP_I_OCR_LOG  as _Logs
{
  key OcrUuid,
      ParentUuid,
      Status,
      IntegrationCorrelationId,
      InvoiceReference,
      InvoiceDate,
      VendorName,
      VendorVatNumber,
      PnpVatNumber,
      TotalVatInclusive,
      VatValue,
      PurchaseOrderNumber,
      AwsS3JsonBucket,
      AwsS3JsonObjectKey,
      AwsS3RawLlmBucket,
      AwsS3RawLlmObjectKey,
      @Semantics.user.createdBy: true
      LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      LocalCreatedAt,
      @Semantics.user.lastChangedBy: true
      LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,

      // Make association public
      _Items,
      _Logs
}
