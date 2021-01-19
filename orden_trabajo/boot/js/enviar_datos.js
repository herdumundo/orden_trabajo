
function enviar_datos_ot(perfil) {

    var url;
       if (perfil == "2") {
          url = "control_ot_ja.aspx";
    }
    else if (perfil == "3") {
          url = "control_ot_n3.aspx";
    }
    
    else {
          url = "control_ot.aspx";
            }

        $.ajax({
            type: "POST",
            url: url,
            data: $("#form_ot").serialize(),
            beforeSend: function () {
                Swal.fire({
                    title: 'PROCESANDO!',
                    html: 'ESPERE<strong></strong>...',
                    allowOutsideClick: false,
                    onBeforeOpen: () => {
                        Swal.showLoading()
                        timerInterval = setInterval(() => {
                            Swal.getContent().querySelector('strong')
                                .textContent = Swal.getTimerLeft()
                        }, 1000)
                    }
                });
            },
            success: function (data) {
                aviso_registro_ot(data.tipo_mensaje, data.mensaje_resultado);
            },

             timeout: 300000,
            error: function () {
                aviso_error_conexion();
            }
        });   
                }

function aviso_error_conexion() {
    Swal.fire({
        title: 'ERROR, DE CONEXION CON LA BASE DE DATOS, INTENTE DE NUEVO',
        type: 'error',
        animation: false,
        customClass: {
            popup: 'animated tada'
        }
    })


}


function enviar_datos_cancel() {
    var url = "control_cancelar.aspx";

    $.ajax({
        type: "POST",
        url: url,
        data: $("#grilla_ot").serialize(),
        success: function (data) {
           $('#contenido_ot').html(data);
        }
    });
}


function enviar_datos() {
    var url = "prueba.aspx";

    $.ajax({
        type: "POST",
        url: url,
        data: $("#form_ot2").serialize(),
        success: function (data) {
            $('#contenido_ot').html(data);
        }
    });
}


function aviso_registro_ot(tipo_mensaje, mensaje_resultado) {
    tipo_mensaje;

    if (tipo_mensaje == "0") {

        swal.fire
            ({
                type: 'success',
                title: mensaje_resultado,
                confirmButtonText: "CERRAR"
            });

        traer_ot();
        $("#txt_ruc").val("");
        $("#txt_bolean_maquina").val("-");
        $("#txt_nombre").val("");
        $("#description").val("");
        $("#txt_problema").val("");
        $("#div_maquina").hide();

        $('#cbox_origen option').prop('selected', function () {
            return this.defaultSelected;
        });
        $('#cbox_origen option').prop('selected', function () {
            return this.defaultSelected;
        });
    }


    else {
        swal.fire({
            type: 'error',
            html:mensaje_resultado,
            confirmButtonText: "CERRAR"
        });

    }






}
