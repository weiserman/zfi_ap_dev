class lhc_zap_i_val_item definition inheriting from cl_abap_behavior_handler.

  private section.

    methods do_item_determination for determine on save
      importing keys for zap_i_val_item~do_item_determination.

    methods do_item_validation for validate on save
      importing keys for zap_i_val_item~do_item_validation.

endclass.

class lhc_zap_i_val_item implementation.

  method do_item_determination.
*Read entities
    read entities of zap_r_val in local mode entity zap_i_val_item  all fields with corresponding #( keys )        result data(lt_items).
    read entities of zap_r_val in local mode entity zap_r_val       all fields with corresponding #( lt_items )    result data(lt_val).
    read entities of zap_r_val in local mode entity zap_i_val_log   all fields with corresponding #( lt_val )      result data(lt_logs).

*Do the RAP validations
*    zap_cl_ap_validation=>rap_validations( exporting it_val_head  = lt_val
*                                                     it_val_items = lt_items
*                                           changing  ct_val_logs  = lt_logs ).
*
**Do the ECC Validations
*    zap_cl_ap_validation=>ecc_validations( exporting it_val_head  = lt_val
*                                                     it_val_items = lt_items
*                                           changing  ct_val_logs  = lt_logs ).
  endmethod.

  method do_item_validation.

*    read entities of zap_r_val in local mode entity zap_i_val_item  all fields with corresponding #( keys )  result data(lt_items).
*    read entities of zap_r_val in local mode entity zap_r_val       all fields with corresponding #( lt_items )    result data(lt_val).
*    read entities of zap_r_val in local mode entity zap_i_val_log   all fields with corresponding #( lt_val )  result data(lt_logs).

**Do the RAP validations
*    zap_cl_ap_validation=>rap_validations( exporting it_val_head  = lt_val
*                                                     it_val_items = lt_items
*                                           changing  ct_val_logs  = lt_logs ).
*
**Do the ECC Validations
*    zap_cl_ap_validation=>ecc_validations( exporting it_val_head  = lt_val
*                                                     it_val_items = lt_items
*                                           changing  ct_val_logs  = lt_logs ).

  endmethod.

endclass.

class lsc_zap_r_val definition inheriting from cl_abap_behavior_saver.

  protected section.
    methods save_modified redefinition.

endclass.

*class lhc_zap_i_val_item definition inheriting from cl_abap_behavior_handler.
*
*
*  private section.
*
**    methods determine_ecc_validation for determine on save
**      importing keys for zap_i_val_item~determine_ecc_validation.
*
*endclass.
class lsc_zap_r_val implementation.
  method save_modified.
  endmethod.
endclass.

class lhc_zap_i_val_log definition inheriting from cl_abap_behavior_handler.

  private section.

    methods determine_onsave for determine on save
      importing keys for zap_i_val_log~determine_onsave.

endclass.

class lhc_zap_i_val_log implementation.

  method determine_onsave.

****Local Data
    data: ld_hdr_status     type zap_de_comm_status.
***          lt_val_create_log type table for create zap_r_val\_Logs,
***          lt_new_val_logs   type zap_cl_ap_validation=>ty_tt_val_logs.
***
*Read entities up from from the logs
    read entities of zap_r_val in local mode entity zap_i_val_log  all fields with corresponding #( keys )     result data(lt_logs).
    read entities of zap_r_val in local mode entity zap_r_val      all fields with corresponding #( lt_logs )  result data(lt_val).
    read entities of zap_r_val in local mode entity zap_i_val_item all fields with corresponding #( lt_val )   result data(lt_items).
***
***
***    zap_cl_ap_validation=>rap_validations( exporting it_val_head  = lt_val
***                                                     it_val_items = lt_items
***                                           changing  ct_val_logs  = lt_new_val_logs ).
***
****Do the ECC Validations
***    zap_cl_ap_validation=>ecc_validations( exporting it_val_head  = lt_val
***                                                     it_val_items = lt_items
***                                           changing  ct_val_logs  = lt_new_val_logs ).
***
***    loop at lt_val into data(ls_val).   "Should be one only
***
****Add the new logs to the existing ones.
***      lt_val_create_log = value #( for ls_new_val_log in lt_new_val_logs index into ld_index
***                                    ( ValUuid = ls_val-ValUuid
***                                       %target = value #( ( %cid            = |LOG{ ld_index }|
***                                                            ValUuid         = ls_val-ValUuid
***                                                            MessageNumber   =  ls_new_val_log-MessageNumber
***                                                            DetailedMessage =  ls_new_val_log-DetailedMessage
***                                                            %control = value #( ValUuid         = if_abap_behv=>mk-on
***                                                                                MessageNumber   = if_abap_behv=>mk-on
***                                                                                DetailedMessage = if_abap_behv=>mk-on  ) ) ) ) ).
***
***    endloop.

*Determine if the log contains any errors
    ld_hdr_status = zap_cl_ap_log_utilities=>determine_log_hdr_status( lt_logs ).

*Update Status based on log
    loop at lt_val assigning field-symbol(<ls_val>).
      <ls_val>-Status = ld_hdr_status.
    endloop.

*Modify communication header entity with new ExternalId
    modify entities of zap_r_val in local mode entity zap_r_val update fields ( Status ) with corresponding #( lt_val ).

  endmethod.

endclass.

class lhc_ZAP_R_VAL definition inheriting from cl_abap_behavior_handler.
  private section.

    methods get_instance_authorizations for instance authorization
      importing keys request requested_authorizations for zap_r_val result result.

    methods get_global_authorizations for global authorization
      importing request requested_authorizations for zap_r_val result result.
    methods do_validation for validate on save
      importing keys for zap_r_val~do_validation.
*                key2 for ZAP_I_VAL_ITEM~do_item_validation.
    methods do_determination for determine on save
      importing keys for zap_r_val~do_determination.
    methods do_createdetermination for determine on modify
      importing keys for zap_r_val~do_createdetermination.

endclass.

class lhc_ZAP_R_VAL implementation.

  method get_instance_authorizations.
  endmethod.

  method get_global_authorizations.
  endmethod.

  method do_validation.

*    data: lt_new_logs type table for read result zap_r_val\_logs.
*
**Read entities
*    read entities of zap_r_val in local mode entity zap_r_val       all fields with corresponding #( keys )    result data(lt_val).
*    read entities of zap_r_val in local mode entity zap_i_val_item  all fields with corresponding #( lt_val )  result data(lt_items).
*    read entities of zap_r_val in local mode entity zap_i_val_log   all fields with corresponding #( lt_val )  result data(lt_logs).
*
**Do the RAP validations
*    zap_cl_ap_validation=>rap_validations( exporting it_val_head  = lt_val
*                                                     it_val_items = lt_items
*                                           changing  ct_val_logs  = lt_new_logs ).
*
**Do the ECC Validations
*    zap_cl_ap_validation=>ecc_validations( exporting it_val_head  = lt_val
*                                                     it_val_items = lt_items
*                                           changing  ct_val_logs  = lt_new_logs ).
*
  endmethod.

  method do_determination.

*Local Data
    data: lt_val_create_log type table for create zap_r_val\_Logs,
          lt_new_val_logs   type zap_cl_ap_validation=>ty_tt_val_logs.

*Read entities up from from the logs
    read entities of zap_r_val in local mode entity zap_r_val      all fields with corresponding #( keys )  result data(lt_val).
    read entities of zap_r_val in local mode entity zap_i_val_log  all fields with corresponding #( lt_val )     result data(lt_logs).
    read entities of zap_r_val in local mode entity zap_i_val_item all fields with corresponding #( lt_val )   result data(lt_items).


    zap_cl_ap_validation=>rap_validations( exporting it_val_head  = lt_val
                                                     it_val_items = lt_items
                                           changing  ct_val_logs  = lt_new_val_logs ).

*Do the ECC Validations
    zap_cl_ap_validation=>ecc_validations( exporting it_val_head  = lt_val
                                                     it_val_items = lt_items
                                           changing  ct_val_logs  = lt_new_val_logs ).

    loop at lt_val into data(ls_val).   "Should be one only

*Add the new logs to the existing ones.
      lt_val_create_log = value #( for ls_new_val_log in lt_new_val_logs index into ld_index
                                    ( ValUuid = ls_val-ValUuid
                                       %target = value #( ( %cid            = |LOG{ ld_index }|
                                                            ValUuid         = ls_val-ValUuid
                                                            MessageNumber   =  ls_new_val_log-MessageNumber
                                                            DetailedMessage =  ls_new_val_log-DetailedMessage
                                                            %control = value #( ValUuid         = if_abap_behv=>mk-on
                                                                                MessageNumber   = if_abap_behv=>mk-on
                                                                                DetailedMessage = if_abap_behv=>mk-on  ) ) ) ) ).

    endloop.
    if lt_val_create_log is not initial.
        modify entities of zap_r_val in local mode
            entity zap_r_val
            create by \_Logs from lt_val_create_log .
    endif.

  endmethod.

  method do_createdetermination.

**Read entities
*    read entities of zap_r_val in local mode entity zap_r_val       all fields with corresponding #( keys )    result data(lt_val).
*    read entities of zap_r_val in local mode entity zap_i_val_item  all fields with corresponding #( lt_val )  result data(lt_items).
*    read entities of zap_r_val in local mode entity zap_i_val_log   all fields with corresponding #( lt_val )  result data(lt_logs).

  endmethod.

endclass.
