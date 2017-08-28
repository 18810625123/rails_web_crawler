window.onload = function() {


    var flush = function(name,data){
        if(name=='provinces'){
            ps = data.provinces;
            ps_e = $('#provinces')
            $('#provinces').html('');
            for(var i=0;i<ps.length;i++){
                ps_e.append(`<option value=`+ps[i].id+`>`+ps[i].name+`</option>`);
            }
        }else if(name=='parent_citys'){
            parent_citys = data.parent_citys
            parent_citys_e = $('#parent_citys')
            $('#parent_citys').html('');
            for(var i=0;i<parent_citys.length;i++){
                parent_citys_e.append(`<option value=`+parent_citys[i].id+`>`+parent_citys[i].name+`</option>`);
            }
        }else if(name=='child_citys'){
            if(data.child_citys.length>0){
                $('#child_citys').show();
                $('#child_citys').html('');
                child_citys = data.child_citys
                child_citys_e = $('#child_citys')
                for(var i=0;i<child_citys.length;i++){
                    child_citys_e.append(`<option value=`+child_citys[i].id+`>`+child_citys[i].name+`</option>`);
                }
            }else{
                $('#child_citys').hide();
            }
        }else if(name=='streets'){
            if(data.streets.length>0){
                $('#streets').show();
                $('#streets').html('');
                streets = data.streets
                streets_e = $('#streets')
                for(var i=0;i<streets.length;i++){
                    streets_e.append(`<option value=`+streets[i].id+`>`+streets[i].name+`</option>`);
                }
            }else{
                $('#streets').hide();
            }
        }
    }
    $('#provinces').bind("change",function(){
        id = $(this).val();
        $.ajax({
            url:'/api/parent_citys/'+id,
            dataType:'json',
            success:function(data){
                if(data.ok){
                    flush('parent_citys',data);
                    flush('child_citys',data);
                    flush('streets',data);
                }else{
                    alert('数据获取失败!');
                }
            }
        });
    });
    $('#parent_citys').bind("change",function(){
        id = $(this).val();
        $.ajax({
            url:'/api/child_citys/'+id,
            dataType:'json',
            success:function(data){
                if(data.ok){
                    flush('child_citys',data);
                    flush('streets',data);
                }else{
                    alert('数据获取失败!');
                }
            }
        });
    });
    $('#child_citys').bind("change",function(){
        id = $(this).val();
        $.ajax({
            url:'/api/streets/'+id,
            dataType:'json',
            success:function(data){
                if(data.ok){
                    flush('streets',data);
                }else{
                    alert('数据获取失败!');
                }
            }
        });
    });
    $.ajax({
        url:'/api/provinces',
        dataType:'json',
        success:function(data){
            if(data.ok){
                flush('provinces',data);
                flush('parent_citys',data);
                flush('child_citys',data);
                flush('streets',data);
            }else{
                alert('数据获取失败!');
            }
        }
    });
}