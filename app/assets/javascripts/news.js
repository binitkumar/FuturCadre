function fetch_news(news_id, type, obj) {
    $('.basic-info').find('.group-link-act').removeClass('group-link-act');
    $(obj).addClass('group-link-act');
    $.ajax({
        context:obj,
        url:"/news/fetch_news?news_id=" + news_id + "&type=" + type,
        type:"GET",
        data:$(obj).serialize(),
        dataType:"json",
        success:function (response) {
            $("#group-link-act").removeClass("group-link-act");
            $("#main_news_page").html(response.html);

        }
    });
    return false;
}