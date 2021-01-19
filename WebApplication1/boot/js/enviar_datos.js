function enviar_datos_ot(perfil)
{
    if (perfil == "2")
    {
        var url = "control_ot_ja.aspx";

        $.ajax
        (
            {
                type: "POST",
                url: url,
                data: $("#form_ot").serialize(),
                success: function (data)
                {
                    $('#contenido_ot').html(data);
                }
            }
        );
    }

   else if (perfil == "3") {
        var url = "control_ot_n3.aspx";

        $.ajax
            (
            {
                type: "POST",
                url: url,
                data: $("#form_ot").serialize(),
                success: function (data) {
                    $('#contenido_ot').html(data);
                }
            }
            );
    }
    else
    {
        var url = "control_ot.aspx";
        $.ajax
            (
            {
                    type: "POST",
                    url: url,
                    data: $("#form_ot").serialize(),
                    success: function (data)
                    {
                        $('#contenido_ot').html(data);
                     }
            }
        );
    }
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