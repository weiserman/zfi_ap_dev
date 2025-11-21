class lsc_zap_r_comm definition inheriting from cl_abap_behavior_saver.

  protected section.

    methods save_modified redefinition.

endclass.

class lsc_zap_r_comm implementation.

  method save_modified.

*Validate that there is content to process
    if create-zap_r_comm is initial and
       update-zap_r_comm is initial and
       delete-zap_r_comm is initial.
      return.
    endif.

*Process CREATED modifications
    loop at create-zap_r_comm into data(ls_created_comm_hdr).

**.register background processing framework (bgPF) process to start the next step
*      if ls_created_comm_hdr-commstatus eq zap_if_constants=>system_status-success and ls_created_comm_hdr-%control-commstatus eq cl_abap_behv=>flag_changed.
*        zap_cl_bgpf_utilities=>start_next_step( id_comm_uuid    = ls_created_comm_hdr-commuuid
*                                                id_current_step = zap_if_constants=>step-email_ingestion ).
*      endif.
*
**.register event to trigger email response to vendor
*      if ls_created_comm_hdr-commstatus eq zap_if_constants=>system_status-rejected and ls_created_comm_hdr-%control-commstatus eq cl_abap_behv=>flag_changed.
*        raise entity event zap_r_comm~respond_to_vendor
*                from value #( for ls_r_comm in create-zap_r_comm (  %param = value #( comm_uuid           = ls_r_comm-CommUuid
*                                                                                      current_step        = ls_r_comm-CurrentStep
*                                                                                      current_step_status = ls_r_comm-CurrentStepStatus
*                                                                                      email_sender_addr   = ls_r_comm-EmailSenderAddr ) ) ).
*      endif.

    endloop.

*Process UPDATED modifications
    loop at update-zap_r_comm into data(ls_updated_comm_hdr).

**.register background processing framework (bgPF) process to start the next step
*      if ls_updated_comm_hdr-commstatus eq zap_if_constants=>system_status-success and ls_updated_comm_hdr-%control-commstatus eq cl_abap_behv=>flag_changed.
*        zap_cl_bgpf_utilities=>start_next_step( id_comm_uuid    = ls_updated_comm_hdr-commuuid
*                                                id_current_step = zap_if_constants=>step-email_ingestion ).
*      endif.
*
**.register event to trigger email response to vendor
*      if ls_created_comm_hdr-commstatus eq zap_if_constants=>system_status-rejected and ls_created_comm_hdr-%control-commstatus eq cl_abap_behv=>flag_changed.
*        raise entity event zap_r_comm~respond_to_vendor
*                from value #( for ls_r_comm in update-zap_r_comm (  %param = value #( comm_uuid           = ls_r_comm-CommUuid
*                                                                                      current_step        = ls_r_comm-CurrentStep
*                                                                                      current_step_status = ls_r_comm-CurrentStepStatus
*                                                                                      email_sender_addr   = ls_r_comm-EmailSenderAddr ) ) ).
*      endif.

    endloop.

  endmethod.

endclass.

class lhc_zap_i_comm_log definition inheriting from cl_abap_behavior_handler.

  private section.

    methods validate_OnCreate for validate on save
      importing keys for zap_i_comm_log~validate_OnCreate.
    methods determine_Status for determine on save
      importing keys for zap_i_comm_log~determine_Status.


endclass.

class lhc_zap_i_comm_log implementation.

  method validate_OnCreate.

*Read communication log entity
    read entities of zap_r_comm in local mode entity zap_i_comm_log all fields with corresponding #( keys ) result data(lt_comm_logs).

*Validate message type
    loop at lt_comm_logs into data(ls_comm_log).

      if ls_comm_log-MessageType <> 'I' and
         ls_comm_log-MessageType <> 'E' and
         ls_comm_log-MessageType <> 'S'.
        append value #( %tky = ls_comm_log-%tky ) to failed-zap_i_comm_log.

        append value #( %tky                = ls_comm_log-%tky
                        %msg                = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                     text     = 'Unknown Message Type' && | | && ls_comm_log-MessageType && | | && 'On Entity Communication Log' )
                      ) to reported-zap_i_comm_log.
      endif.

    endloop.

  endmethod.

  method determine_Status.

*Local Data
    data: ld_hdr_status type zap_de_comm_status.

*Read entities
    read entities of zap_r_comm in local mode entity zap_i_comm_log all fields with corresponding #( keys ) result data(lt_logs).
    read entities of zap_r_comm in local mode entity zap_r_comm all fields with corresponding #( lt_logs ) result data(lt_comm_headers).

*Determine if the log contains any errors
    ld_hdr_status = zap_cl_ap_log_utilities=>determine_log_hdr_status( lt_logs ).

*Update CommStatus based on log
    loop at lt_comm_headers assigning field-symbol(<ls_comm_header>).
      <ls_comm_header>-commstatus        = ld_hdr_status.
      <ls_comm_header>-currentstep       = zap_if_constants=>step-email_ingestion.
      <ls_comm_header>-currentstepstatus = ld_hdr_status.
      <ls_comm_header>-commlogid         = <ls_comm_header>-commlogid + 1.
      get time stamp field <ls_comm_header>-currentstepproccessedat.

      loop at lt_logs assigning field-symbol(<ls_log>) where %data-commuuid = <ls_comm_header>-commuuid.
        <ls_log>-logid = <ls_comm_header>-commlogid.
      endloop.
    endloop.

*Modify communication header entity with new data
    modify entities of zap_r_comm in local mode entity zap_r_comm update fields ( CommStatus CommLogId CurrentStep CurrentStepStatus CurrentStepProccessedAt ) with corresponding #( lt_comm_headers ).

*Modify communication log entity with new data
    modify entities of zap_r_comm in local mode entity zap_i_comm_log update fields ( LogId ) with corresponding #( lt_logs ).

  endmethod.



endclass.

class lhc_zap_i_attach definition inheriting from cl_abap_behavior_handler.

  private section.

    methods validate_oncreate for validate on save
      importing keys for zap_i_attach~validate_oncreate.

endclass.

class lhc_zap_i_attach implementation.

  method validate_oncreate.

*Local Data
    data: ld_has_invoice_attachment type abap_bool.

*Read attachment entity
    read entities of zap_r_comm in local mode entity zap_i_attach all fields with corresponding #( keys ) result data(lt_attachments).
    read entities of zap_r_comm in local mode entity zap_i_attach by \_Comm all fields with corresponding #( lt_attachments ) result data(lt_comm_headers).

DATA lt_comm_log TYPE TABLE FOR CREATE zap_r_comm\_Logs.

    loop at lt_comm_headers into data(ls_comm_header2) where commstatus = zap_if_constants=>system_status-success.

        lt_comm_log = value #( ( commuuid = ls_comm_header2-commuuid
                                 %cid_ref = 'OCR_LOG_1'
                                       %target = value #( ( %cid          = 'OCR_LOG_1'
                                                            commuuid = ls_comm_header2-commuuid
                                                            MessageNumber = zap_if_constants=>system_status-success
                                                            DetailedMessage   = 'Invoice Attachment Validated Successfully'
                                                            %control = value #( DetailedMessage       = if_abap_behv=>mk-on
                                                                                MessageNumber = if_abap_behv=>mk-on ) ) ) ) ).

        modify entities of zap_r_comm in local mode entity zap_r_comm  create by \_Logs from corresponding #( lt_comm_log ).

      endloop.


    modify entities of zap_r_comm in local mode entity zap_r_comm update fields ( ExternalId ) with corresponding #( lt_comm_headers ).

*Validate attachment type
    loop at lt_comm_headers into data(ls_comm_header) where commstatus = zap_if_constants=>system_status-success.

      loop at lt_attachments into data(ls_attachment) where parentuuid = ls_comm_header-commuuid.

        if ls_attachment-AttachmentType <> zap_if_constants=>attachment-attachment_type_invoice and ls_attachment-AttachmentType <> space.
          append value #( %tky = ls_attachment-%tky ) to failed-zap_i_attach.
          append value #( %tky = ls_attachment-%tky
                          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                        text     = 'Unknown Attachment Type' && | | && ls_attachment-AttachmentType && | | && 'On Entity Attachment' ) ) to reported-zap_i_attach.
        endif.

        if ls_attachment-AttachmentType = zap_if_constants=>attachment-attachment_type_invoice.
          ld_has_invoice_attachment = abap_true.
        endif.

      endloop.

*Validate that at least one invoice attachment exists
      if ld_has_invoice_attachment = abap_false.
        loop at lt_attachments into ls_attachment.
          append value #( %tky = ls_attachment-%tky ) to failed-zap_i_attach.
          append value #( %tky = ls_attachment-%tky
                          %msg  = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                         text     = 'At Least One INVOICE Attachment Is Required' ) ) to reported-zap_i_attach.
        endloop.
      endif.

    endloop.

  endmethod.

endclass.

class lhc_ZAP_R_COMM definition inheriting from cl_abap_behavior_handler.
  private section.

    methods get_instance_authorizations for instance authorization
      importing keys request requested_authorizations for zap_r_comm result result.

    methods get_global_authorizations for global authorization
      importing request requested_authorizations for zap_r_comm result result.

    methods determine_onsave_externalid for determine on save
      importing keys for zap_r_comm~determine_onsave_externalid.
    methods validate_oncreate for validate on save
      importing keys for zap_r_comm~validate_oncreate.
    methods determine_onsave_vendornumber for determine on save
      importing keys for zap_r_comm~determine_onsave_vendornumber.

endclass.

class lhc_ZAP_R_COMM implementation.

  method get_instance_authorizations.
  endmethod.

  method get_global_authorizations.
  endmethod.

  method determine_onsave_externalid.

*Read communication header entity
    read entities of zap_r_comm in local mode entity zap_r_comm all fields with corresponding #( keys ) result data(lt_comm_headers).

*Iterate through entity and assign ExternalId
    loop at lt_comm_headers assigning field-symbol(<ls_comm_header>).
      try.
          cl_numberrange_runtime=>number_get( exporting nr_range_nr = zap_if_constants=>number_range-comm_external_nr_range_nr
                                                        object      = zap_if_constants=>number_range-comm_external_id_object
                                                        quantity    = 1
                                              importing number = data(ld_number_range_key) ).

          <ls_comm_header>-externalid = ld_number_range_key+10(10).

        catch cx_number_ranges.
      endtry.

    endloop.

*Modify communication header entity with new ExternalId
    modify entities of zap_r_comm in local mode entity zap_r_comm update fields ( ExternalId ) with corresponding #( lt_comm_headers ).

  endmethod.

  method validate_OnCreate.

*Read communication header entity
    read entities of zap_r_comm in local mode entity zap_r_comm all fields with corresponding #( keys ) result data(lt_comm_headers).

*Iterate through entity and validate elements
    loop at lt_comm_headers into data(ls_comm_header).

      if ls_comm_header-channel <> zap_if_constants=>comm_channel-email.
        append value #( %tky = ls_comm_header-%tky ) to failed-zap_r_comm.
        append value #( %tky = ls_comm_header-%tky
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                       text     = 'Unknown Channel' && | | && ls_comm_header-channel && | | && 'On Entity Email' ) ) to reported-zap_r_comm.
      endif.

      if ls_comm_header-externalid is initial.
        append value #( %tky = ls_comm_header-%tky ) to failed-zap_r_comm.
        append value #( %tky = ls_comm_header-%tky
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                       text     = 'ExternalId is required on Entity Email' ) ) to reported-zap_r_comm.
      endif.

    endloop.

  endmethod.

  method determine_onsave_vendornumber.
  endmethod.

endclass.
