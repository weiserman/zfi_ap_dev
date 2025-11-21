interface zap_if_constants
  public.

  constants: begin of system_status,
               success     type zap_de_message_num value '001',
               in_progress type zap_de_message_num value '002',
               warning     type zap_de_message_num value '003',
               error       type zap_de_message_num value '004',
               rejected    type zap_de_message_num value '005',
               completed   type zap_de_message_num value '006',
             end of system_status.

  constants: begin of step,
               email_ingestion type zap_de_current_step value 'EMAIL_INGESTION',
               ocr_invoice     type zap_de_current_step value 'OCR_INVOICE',
               validation      type zap_de_current_step value 'VALIDATION',
             end of step.

  constants: begin of attachment,
               attachment_type_invoice type zap_de_attachment_type value 'INVOICE',
             end of attachment.

  constants: begin of number_range,
               comm_external_id_object   type cl_numberrange_runtime=>nr_object   value 'ZAP_EXT_ID',
               comm_external_nr_range_nr type cl_numberrange_runtime=>nr_interval value '1',
             end of number_range.

  constants: begin of comm_channel,
               email type zap_de_channel value 'EMAIL',
             end of comm_channel.

endinterface.
