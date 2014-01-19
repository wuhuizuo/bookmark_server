/**
 * Created by wuhuizuo on 14-1-19.
 */
function init_tag() {
    $('#nav_tool_bar').append(
        '<button class="btn btn-success tag_add" data-toggle="modal" data-target="#tag_dialog">\
            <span class="glyphicon glyphicon-plus"></span><span class="glyphicon glyphicon-tag"></span>\
        </button>'
    );

    $('div#tag_dialog .submit-trigger').on('click', function () {
        $('div#tag_dialog form').submit();
    });

    $('.tag_edit').on('click', function (event) {
        event.preventDefault();
        var tag = $(this).closest('div.tag');
        set_tag_dialog('edit', tag.find('#tag_name').text(), '编辑标签');
    });
    $('.tag_add').on('click', function () {
        set_tag_dialog('add', '', '添加标签');
    });
    $('.tag_delete').on('click', function (event) {
        event.preventDefault();
        var tag = $(this).closest('div.tag');
        set_tag_dialog('delete', tag.find('#tag_name').text(), '确定删除此标签吗?');
    });
}

function set_tag_dialog(opr, tag_name, title) {
    if (opr == 'delete') {
        $('div#tag_dialog [name]').prop('readonly', true);
    } else {
        $('div#tag_dialog [name]').prop('readonly', false);
    }
    $('div#tag_dialog [name=opr]').val(opr);
    $('div#tag_dialog [name=tag_name]').val(tag_name);
    $('div#tag_dialog [name=old_tag_name]').val(tag_name);
    $('div#tag_dialog #tagLabel').val(title);
}
