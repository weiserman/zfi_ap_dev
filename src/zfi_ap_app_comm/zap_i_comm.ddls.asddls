@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Communication Header Interface View'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType: #COMPOSITE
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #L,
    dataClass: #MIXED
}
define view entity ZAP_I_COMM
  as select from ZAP_B_COMM
{
  key CommUuid,
      ExternalId,
      Channel,
      CountryCode,
      IntegrationCorrelationId,
      CommStatus,
      CommLogId,
      CurrentStep,
      CurrentStepStatus,
      CurrentStepProccessedAt,
      EmailId,
      EmailSenderAddr,
      EmailSubject,
      EmailSentAt,
      EmailReceivedAt,
      VendorNumber,
      InvoiceReference,
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt
}
