@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Communication Header Root View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZAP_R_COMM
  as select from ZAP_I_COMM
  composition [0..*] of ZAP_I_ATTACH   as _Attachments
  composition [0..*] of ZAP_I_COMM_LOG as _Logs

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
      @Semantics.user.createdBy: true
      LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      LocalCreatedAt,
      @Semantics.user.lastChangedBy: true
      LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,

      //Associations
      _Attachments,
      _Logs

}
