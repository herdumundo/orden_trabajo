var ruta_contenedores = "./contenedores/";
var ruta_controles = "./controles/";
var ruta_grillas = "./grillas/";
var ruta_consultas = "./consultas/";
function anular_registro_ot_admin(id, txt_comentario) {

    var descripcion = $("#txt_comentario").val();

    if (descripcion.length == 0) {

        swal.fire({
            type: 'error',
            title: "ERROR INGRESE MOTIVO",

            confirmButtonText: "CERRAR"
        });
    }
    else {



        Swal.fire({
            title: 'CANCELACION DE  PEDIDO',
            text: "DESEA CANCELAR EL PEDIDO?",
            type: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'SI, CANCELAR PEDIDO!',
            cancelButtonText: 'NO!'
        }).then((result) => {
            if (result.value) {

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
                $.ajax({
                    type: "POST",
                    url: ruta_controles+"control_cancelar.aspx",
                    data: ({ id: id, txt_comentario: txt_comentario  }),
                    dataType: "html",
                    success: function (data) {

                        aviso_registro_cancelacion(data, "1");
                        return data;
                    },
                    timeout: 150000,
                    error: function () {
                        aviso_error_conexion();
                    }
                });

            }
        })



 
     
    }






       }
function aviso_registro_cancelacion(mensaje,tipo) {
    var resultado = mensaje;
    resultado_mensaje = mensaje.replace(/\s/g, '');
    if (resultado_mensaje == "1") {

        swal.fire({
            type: 'success',
            title: "CANCELADO CON EXITO",
            confirmButtonText: "CERRAR"
        });
        if (tipo == "1") {

            traer_informe_ot_admin();
        }
       else if (tipo == "3") {

            traer_informe_ot_mant();
        }
        else if (tipo == "4") {

            traer_informe_verificacion();
        }
       
    }


    else {
        swal.fire({
            type: 'error',
            title: resultado,
            confirmButtonText: "CERRAR"
        });
       
    }
}






function aviso_cancelacion(mensaje,tipo_resultado, tipo) {
 

    if (tipo_resultado == "1") {

        swal.fire({
            type: 'success',
            title: mensaje,
            confirmButtonText: "CERRAR"
        });
        if (tipo == "1") {

            traer_informe_ot_admin();
        }
        else if (tipo == "3") {

            traer_informe_ot_mant();
        }
        else if (tipo == "4") {

            traer_informe_verificacion();
        }

    }


    else {
        swal.fire({
            type: 'error',
            html: mensaje,
            confirmButtonText: "CERRAR"
        });

    }
}


 
 function anular_registro_mant(id, txt_comentario) {
    var descripcion = $("#txt_comentario").val();
    if (descripcion.length == 0) {
         swal.fire({
            title: "ERROR INGRESE MOTIVO",
            confirmButtonText: "CERRAR"
        });
     }

         else {

    Swal.fire({
            title: 'CANCELACION DE  PEDIDO',
            text: "DESEA CANCELAR EL PEDIDO?",
            type: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'SI, CANCELAR PEDIDO!',
            cancelButtonText: 'NO!'
        }).then((result) => {
            if (result.value) {

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
                $.ajax({
                    type: "POST",
                    url: ruta_controles +"control_cancelar.aspx",
                    data: ({ id: id, txt_comentario: txt_comentario }),
                    dataType: "html",
                    success: function (data) {

                        aviso_registro_cancelacion(data, "3");
                        return data;
                    },
                    timeout: 150000,
                    error: function () {
                        aviso_error_conexion();
                    }
                });

            }
        })
 
    }
} 
 
function cerrar_registro_verificacion(id, motivo) {

    Swal.fire({
        title: 'RECHAZO DE RESOLUCION',
        text: "DESEA RECHAZAR LA RESOLUCION?",
        type: 'warning',
        html: "<textarea style='text- transform: uppercase; width: 400px; height: 80px'  name = 'txt_motivo_rechazo' id='txt_motivo_rechazo' class='form - control' placeholder='AGREGAR MOTIVO'></textarea>",
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'SI!',
        cancelButtonText: 'NO!'
    }).then((result) => {
        if (result.value) {


            var motivo = $('#txt_motivo_rechazo').val();

            if ($('#txt_motivo_rechazo').val().length == 0) {
                swal.fire({
                    type: 'error',
                    title: "DEBES INGRESAR EL MOTIVO.",
                    confirmButtonText: "CERRAR"
                });
            }

            else {
            

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
            $.ajax({
                type: "POST",
                url: ruta_controles +"control_rechazar_resolucion.aspx",
                data: ({ id: id, motivo: motivo }),
                
                success: function (data) {


                     

                    aviso_cancelacion(data.mensaje_resultado, data.tipo_mensaje, "4");
                    
                },
                timeout: 250000,
                error: function () {
                    aviso_error_conexion();
                }
            });

            }
        }
    })

} 