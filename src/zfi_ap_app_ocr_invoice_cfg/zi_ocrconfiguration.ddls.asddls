@EndUserText.label: 'OCR Configuration'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_OcrConfiguration
  as select from ZAP_A_OCR_CFG
  association to parent ZI_OcrConfiguration_S as _OcrConfigurationAll on $projection.SingletonID = _OcrConfigurationAll.SingletonID
{
  key OCR_TYPE as OcrType,
  OCR_TYPE_DESCRIPTION as OcrTypeDescription,
  AWS_S3_PROMPT_BUCKET as AwsS3PromptBucket,
  AWS_S3_PROMPT_OBJECT_KEY as AwsS3PromptObjectKey,
  AWS_OPT_FORCE_TEXTRACT_REDO as AwsOptForceTextractRedo,
  AWS_OPT_LLM_ONLY as AwsOptLlmOnly,
  AWS_BEDROCK_MODEL_ID as AwsBedrockModelId,
  @Semantics.user.createdBy: true
  LOCAL_CREATED_BY as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  LOCAL_CREATED_AT as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  @Consumption.hidden: true
  LOCAL_LAST_CHANGED_BY as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  @Consumption.hidden: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  @Consumption.hidden: true
  1 as SingletonID,
  _OcrConfigurationAll
}
