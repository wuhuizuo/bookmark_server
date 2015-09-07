/**
 * Created by wuhuizuo on 14-1-19.
 */
function init_bm() {
    $('#nav_tool_bar').append(
        '<button class="btn btn-success bm_add" data-toggle="modal" data-target="#bm_dialog">\
            <span class="glyphicon glyphicon-plus"></span><span class="glyphicon glyphicon-star-empty"></span>\
        </button>'
    );

    $('.bm_edit').on('click', function (event) {
        event.preventDefault();
        var bookmark = $(this).closest('div.bookmark');
        $('div#bm_dialog [name]').prop('readonly', false);
        $('div#bm_dialog [name=opr]').val('edit');
        $('div#bm_dialog [name=bm_id]').val(bookmark.find('#bm_id').val());
        $('div#bm_dialog [name=tags]').val(bookmark.find('#tags').text());
        $('div#bm_dialog [name=desc]').val(bookmark.find('#desc').text());
        $('div#bm_dialog [name=url]').val(bookmark.find('#url').attr("href"));
        $('div#bm_dialog #bmLabel').text('编辑书签');
    });
    $('.bm_add').on('click', function () {
        $('div#bm_dialog [name]').prop('readonly', false);
        $('div#bm_dialog [name=opr]').val('add');
        $('div#bm_dialog [name=bm_id]').val('');
        $('div#bm_dialog [name=tags]').val('');
        $('div#bm_dialog [name=desc]').val('');
        $('div#bm_dialog [name=url]').val('');
        $('div#bm_dialog #bmLabel').text('添加书签');
    });
    $('.bm_delete').on('click', function (event) {
        event.preventDefault();
        var bookmark = $(this).closest('div.bookmark');
        $('div#bm_dialog [name]').prop('readonly', true);
        $('div#bm_dialog [name=opr]').val('delete');
        $('div#bm_dialog [name=bm_id]').val(bookmark.find('#bm_id').val());
        $('div#bm_dialog [name=tags]').val(bookmark.find('#tags').text());
        $('div#bm_dialog [name=desc]').val(bookmark.find('#desc').text());
        $('div#bm_dialog [name=url]').val(bookmark.find('#url').attr("href"));
        $('div#bm_dialog #bmLabel').text('确定删除此书签吗?');
    });
    $('div#bm_dialog .submit-trigger').on('click', function () {
        $('div#bm_dialog form').submit();
    });
}