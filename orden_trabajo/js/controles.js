var ruta_contenedores = "./contenedores/";
var ruta_controles = "./controles/";
var ruta_grillas = "./grillas/";
var ruta_consultas = "./consultas/";
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
            url: ruta_controles +"control_ot.aspx",
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
    var url = ruta_controles +"control_cancelar.aspx";

    $.ajax({
        type: "POST",
        url: url,
        data: $("#grilla_ot").serialize(),
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

 
    function aprobar_registro(id, descripcion, detalle,proveedor) {

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

                aprobar_ot(id, descripcion, detalle, $('#aviso').val(), proveedor);

            }
        })
    }









function aprobar_ot(id, descripcion, detalle, notas, proveedor) {


    $.ajax({
        type: "POST",
        url: ruta_controles + "control_aprobar.aspx",
        data: ({ id: id, descripcion: descripcion, detalle: detalle, notas: notas, proveedor: proveedor }),
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
            aviso_registro_aprobacion(data.tipo_mensaje, data.mensaje_resultado, "2");
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

 


 
function validar_formato_area_mant(area_get) {
    $('#cbox_encargado_mant option').filter(function () {
        return this.id === area_get
    }).prop('selected', true);
}
function deseleccionar_multiselect() {
    $("#proveedor option:selected").prop("selected", false);

}
function deseleccionar_proveedor() {
    $("#proveedor option:selected").prop("selected", false);
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
        insertar_registro_asignacion(operario, nro_ot, combo_proveedor, $('#nota').val());

    }
}
function insertar_registro_asignacion(operario, nro_ot, cbox_proveedor, nota) {


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
        url: ruta_controles + "control_asignacion.aspx",
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
        html: "<a>DETALLE DE RESOLUCION</a><textarea style='text- transform: uppercase; width: 400px; height: 80px'  name = 'txt_resolucion' id='txt_resolucion' class='form - control' placeholder='INGRESE EL DETALLE DE LA RESOLUCION'></textarea>" +
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
                aprobacion_resolucion(id, resolucion, maquina, descripcion, detalle, $('#nota').val());
            }


        }
    })
     
}


function form_aprobar_mant(proveedor, id,detalle,descripcion) {

    var html;

    if (proveedor == "LOG") {
        html="   <form id='form_cuadro_operarios'> <a>OPERARIOS DE LOGISTICA</a>\n\
                            <select style = ' width: 400px; height: 80px' name = 'cbox_encargado_mant'   id = 'cbox_encargado_mant' class='form - control'  multiple = 'multiple' >\n\
                            </select > <br><br><textarea style='text - transform: uppercase; width: 400px; height: 80px'  name = 'nota' id='nota' class='form - control' placeholder='AGREGAR NOTA'></textarea><br><br><br> <input type='submit'   value='REGISTRAR' class='form-control bg-success btn'> </form> ";
    }
    else {
        html = "   <form id='form_cuadro_operarios'>   <div id='combo' class='form - group'> <a>TERCERIZADOS</a>\n\
                            <input  type='checkbox' data-toggle='toggle'  data - on='SI' data - off='NO' id = 'check_terc' data - onstyle='success' data - offstyle='warning' >\n\
                            <select style = ' display:none; width: 400px; height: 80px' name = 'proveedor'   id = 'proveedor' class='form - control'  multiple = 'multiple' >\n\
                            </select ><br><br>\n\
                            </div >\n\
                            <a> ENCARGADO DE MANTENIMIENTO</a >\n\
                            <select style = 'font-weight: bold;' class='form-control' name = 'cbox_encargado_mant' id = 'cbox_encargado_mant' >\n\
                            </select ><br><br><textarea style='text - transform: uppercase; width: 400px; height: 80px'  name = 'nota' id='nota' class='form - control' placeholder='AGREGAR NOTA'></textarea>\n\
                            <br><br><br><input type='submit' value='REGISTRAR' class='form-control bg-success btn'>  </form> ";
    }

    
    Swal.fire({
        title: 'ASIGNACION DE OPERARIOS',
        text: "DESEA REGISTRAR LA RESOLUCION?",
        type: 'warning',
        html: html,

        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        showCancelButton: false,
        showConfirmButton: false
    });
   
    if (proveedor == "MANT") {

        $.get(ruta_consultas + 'combo_operarios.aspx', ({ tipo_registro: proveedor }), function (res) {
            $("#cbox_encargado_mant").html(res.combo);
            $('#check_terc').bootstrapToggle();

            $.get(ruta_consultas + 'combo_terc.aspx', function (res) {
                $("#proveedor").html(res.combo);

                $('#form_cuadro_operarios').on('submit', function (e) { e.preventDefault(); aprobar_registro_mant(proveedor, id, descripcion, detalle, $("#nota").val()); });

                $(function () {
                    $('#check_terc').change(function () {
                        if ($(this).prop("checked") == true) {
                            $('#proveedor').show();
                            $("#proveedor").prop('required', true);

                            deseleccionar_multiselect();
                        }
                        else {
                            $('#proveedor').hide();
                            $("#proveedor").prop('required', false);

                            deseleccionar_proveedor();
                        }
                    });
                });
            });
        });
    }
    else {

        $.get(ruta_consultas + 'combo_operarios.aspx', ({ tipo_registro: proveedor }), function (res) {
            $("#cbox_encargado_mant").html(res.combo);
            $('#check_terc').bootstrapToggle();
            $('#form_cuadro_operarios').on('submit', function (e) { e.preventDefault(); aprobar_registro_mant(proveedor, id, descripcion, detalle, $("#nota").val()); });

        });
    }
   
     
}




function aprobar_registro_mant(tipo_registro, id, descripcion, detalle, nota) {
  // tipo_registro = log o mant

    var cbox_operarios_logistica = $('#cbox_encargado_mant option:selected').toArray().map(item => item.value).join();
    var cbox_terc = $('#proveedor option:selected').toArray().map(item => item.value).join();
    var cbox_encargado = $("#cbox_encargado_mant :selected").val();
 
    //alert(tipo_registro + ' ' + id + ' ' + descripcion + '  ' + nota + ' ' + detalle + cbox_operarios_logistica + cbox_terc);

 
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


            $.ajax({
                type: "POST",
                url: ruta_controles + "control_aprobar_mant.aspx",
                data: ({ id: id, cbox_terc: cbox_terc, cbox_encargado: cbox_encargado, descripcion: descripcion, detalle: detalle, nota: nota, tipo_registro: tipo_registro, operarios_logistica: cbox_operarios_logistica }),
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
                 } 
            });






         }
    })
    


}








function aprobacion_resolucion(id, txt_resolucion, maquina, descripcion, detalle, nota) {

    $.ajax({
        type: "POST",
        url: ruta_controles + "control_resolucion.aspx",
        data: ({ id: id, txt_resolucion: txt_resolucion, maquina: maquina, descripcion: descripcion, detalle: detalle, nota: nota }),
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





function aprobacion_verificacion(id, nota) {

    $.ajax({
        type: "POST",
        url: ruta_controles + "control_verificacion.aspx",
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
