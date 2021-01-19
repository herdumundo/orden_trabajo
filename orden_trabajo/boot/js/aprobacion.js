function aprobar_registro(id, descripcion, detalle) {
     
    Swal.fire({
        title: 'APROBACION DE PEDIDO DE TRABAJO',
        text: "DESEA APROBAR EL PEDIDO?",
        type: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        html: "<input type='text' class='form-control' id='aviso' placeholder='AGREGAR NOTA'>",
        confirmButtonText: 'APROBAR!',
        cancelButtonText: 'CANCELAR!'
    }).then((result) => {
        if (result.value) {

            aprobar_ot(id, descripcion, detalle, $('#aviso').val());
        
        }
    })

     
}









function aprobar_ot(id, descripcion, detalle,notas) {


    $.ajax({
        type: "POST",
        url: "control_aprobar.aspx",
        data: ({ id: id, descripcion: descripcion, detalle: detalle,notas:notas }),
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
            aviso_registro_aprobacion(data.tipo_mensaje, data.mensaje_resultado,"2");
        },

        timeout: 300000,
        error: function () {
            aviso_error_conexion();
        }
    });




}
 

function aviso_registro_aprobacion(tipo_mensaje, mensaje_resultado, tipo) {
    if (tipo_mensaje == "0") {

        swal.fire({
            type: 'success',
            title: mensaje_resultado,
            confirmButtonText: "CERRAR"
        });
        if (tipo == "2") {

            traer_informe_ot_admin();
        }
        else if (tipo == "3") {

            traer_informe_ot_mant();
        }
        else if (tipo == "4") {

            traer_informe_asignacion();
        }
        else if (tipo == "5") {

            traer_informe_resolucion();
        }
        else if (tipo == "6") {

            traer_informe_verificacion();
        }
    }


    else {
        swal.fire({
            type: "error",
            html: mensaje_resultado,
            confirmButtonText: "CERRAR"
        });

    }
}

function aprobar_registro_mant(id) {
    var cbox_proveedor = $('#cbox_proveedor option:selected').toArray().map(item => item.value).join();
    var combo_proveedor = cbox_proveedor.trim();
    var cbox_encargado = $("#cbox_encargado_mant :selected").val();
    var descripcion = $("#descripcion").val();
    var detalle = $("#detalle").val();




    Swal.fire({
        title: 'APROBACION PEDIDO',
        text: "DESEA APROBAR EL PEDIDO?",
        type: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'SI, APROBAR!',
        cancelButtonText: 'NO, CANCELAR!'
    }).then((result) => {
        if (result.value) {

            aprobar_mant(id, combo_proveedor, cbox_encargado, descripcion, detalle, $("#nota").val());
        }
    })

 

}


function aprobar_mant(id,  combo_proveedor,  cbox_encargado,  descripcion,  detalle,nota )

{
    $.ajax({
        type: "POST",
        url: "control_aprobar_mant.aspx",
        data: ({ id: id, combo_proveedor: combo_proveedor, cbox_encargado: cbox_encargado, descripcion: descripcion, detalle: detalle, nota: nota}),
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

        aviso_registro_aprobacion(data.tipo_mensaje, data.mensaje_resultado, "3");
        return data;
     },

    timeout: 300000,
    error: function () {
        aviso_error_conexion();
    }
            });

        }

 function validar_formato_area_mant(area_get) {
    $('#cbox_encargado_mant option').filter(function () {
        return this.id === area_get
    }).prop('selected', true);
}
function deseleccionar_multiselect() {
    $("#cbox_operario option:selected").prop("selected", false);

}
function deseleccionar_proveedor() {
    $("#cbox_proveedor option:selected").prop("selected", false);
}



function validar_asignacion() {
    var cbox = $('#cbox_operario').val();
    var cbox_prov = $('#cbox_proveedor').val();

    if (cbox.length === 0 && cbox_prov === "-") {

        swal.fire({

            title: "ERROR, SELECCIONAR OPERARIO!!!",

            confirmButtonText: "CERRAR"
        });
    }
    else {

        var operario = $('#cbox_operario option:selected').toArray().map(item => item.value).join();
        var nro_ot = $('#id_orden').val();
        var cbox_proveedor = $('#cbox_proveedor option:selected').toArray().map(item => item.value).join();
        var combo_proveedor = cbox_proveedor.trim();
        insertar_registro_asignacion(operario, nro_ot, combo_proveedor,$('#nota').val());

     }
}
function insertar_registro_asignacion(operario, nro_ot, cbox_proveedor,nota) {
    

     Swal.fire({
         title: 'ASIGNACION DE OPERARIOS',
         text: "DESEA APROBAR LA ASIGNACION?",
         type: 'warning',
         showCancelButton: true,
         confirmButtonColor: '#3085d6',
         cancelButtonColor: '#d33',
         confirmButtonText: 'SI, APROBAR!',
         cancelButtonText: 'NO, CANCELAR!'
     }).then((result) => {
         if (result.value) {
 
             aprobar_asignacion_operarios(operario, nro_ot, cbox_proveedor, nota);
         }
     })
}  


function aprobar_asignacion_operarios(operario, nro_ot, cbox_proveedor, nota) {

    $.ajax({
        type: "POST",
        url: "control_asignacion.aspx",
        data: ({ operario: operario, nro_ot: nro_ot, cbox_proveedor: cbox_proveedor, nota: nota }),
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

            aviso_registro_aprobacion(data.tipo_mensaje, data.mensaje_resultado, "4");
            return data;
        },

        timeout: 300000,
        error: function () {
            aviso_error_conexion();
        }
    });
}

function enviar_resolucion(id, maquina, descripcion, detalle) {

 

        Swal.fire({
            title: 'CARGA DE RESOLUCION',
            text: "DESEA REGISTRAR LA RESOLUCION?",
            type: 'warning',
            html: "<a>DETALLE DE RESOLUCION</a><textarea style='text- transform: uppercase; width: 400px; height: 80px'  name = 'txt_resolucion' id='txt_resolucion' class='form - control' placeholder='INGRESE EL DETALLE DE LA RESOLUCION'></textarea>"+
                "<br><br> <a>AGREGAR NOTA.</a><textarea style='text- transform: uppercase; width: 400px; height: 80px' name='nota' id='nota' class='form - control' placeholder='AGREGAR NOTA (OPCIONAL)'></textarea> <br>",
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'SI, REGISTRAR!',
                cancelButtonText: 'NO, CANCELAR!'
        }).then((result) => {
            if (result.value) {

                var resolucion = $('#txt_resolucion').val();

                if (resolucion.length == 0) {
                    Swal.fire({
                        title: 'ERROR, DEBE INGRESAR EL DETALLE DE RESOLUCION.',
                        type: 'error',
                        animation: true,
                        customClass: {
                            popup: 'animated tada'
                        }
                    })
                }

                else {
                    aprobacion_resolucion(id, resolucion,maquina, descripcion, detalle , $('#nota').val());
                }

               
            }
        })


  

   

}     

function aprobacion_resolucion(id, txt_resolucion, maquina, descripcion, detalle, nota) {

    $.ajax({
        type: "POST",
        url: "control_resolucion.aspx",
        data: ({ id: id, txt_resolucion: txt_resolucion, maquina: maquina, descripcion: descripcion, detalle: detalle, nota: nota}),
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

            aviso_registro_aprobacion(data.tipo_mensaje, data.mensaje_resultado, "5");
            return data;
        },

        timeout: 300000,
        error: function () {
            aviso_error_conexion();
        }
    });
}

  

function aprobar_verificacion(id) {




    Swal.fire({
        title: 'APROBACION DE VERIFICACION',
        text: "DESEA APROBAR LA VERIFICACION?",
        type: 'warning',
        html: "<textarea style='text- transform: uppercase; width: 400px; height: 80px'  name = 'nota' id='nota' class='form - control' placeholder='AGREGAR NOTA'></textarea>",
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'SI, APROBAR!',
        cancelButtonText: 'NO, CANCELAR!'
    }).then((result) => {
        if (result.value) {

            aprobacion_verificacion(id, $('#nota').val());
        }
    })
} 





function aprobacion_verificacion(id,nota) {

    $.ajax({
        type: "POST",
        url: "control_verificacion.aspx",
        data: ({ id: id, nota: nota }),
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

            aviso_registro_aprobacion(data.tipo_mensaje, data.mensaje_resultado, "6");
            return data;
        },

        timeout: 300000,
        error: function () {
            aviso_error_conexion();
        }
    });
}