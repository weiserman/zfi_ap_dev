@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Attachments Inferface View'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType: #COMPOSITE
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #L,
    dataClass: #MIXED
}
define view entity ZAP_I_ATTACH
  as select from ZAP_B_ATTACH
  association to parent ZAP_R_COMM as _Comm on $projection.ParentUuid = _Comm.CommUuid
{
  key AttachmentUuid,
      ParentUuid,
      AttachmentId,
      AttachmentType,
      FileName,
      FileExtension,
      FileSize,
      AwsS3FileArn,
      AwsS3Bucket,
      AwsS3ObjectKey,
      AwsS3SignedUrl,
      AwsS3SignedUrlExpiryDate,
      @Semantics.user.createdBy: true
      LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      LocalCreatedAt,
      @Semantics.user.lastChangedBy: true
      LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,
      
      //Association
      _Comm
}
