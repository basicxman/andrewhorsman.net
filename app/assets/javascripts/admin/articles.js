$.fn.extend({
  parentRow: function() {
    return $(this).parent("td").parent("tr");
  }
});

$(function() {
  stopFormBrowserDefault("dragover");
  stopFormBrowserDefault("dragenter");
  if ($(".article-admin-form").length) {
    addDropCapability($(".article-admin-form"));
  }
});

function addDropCapability(elm) {
  $(elm).get(0).addEventListener("drop", function(e) {
    e.stopPropagation();
    e.preventDefault();

    var file = e.dataTransfer.files[0];
    var reader = new FileReader();
    reader.onprogress = function(e) { };
    reader.onload = function(e) {
      fillForm(e.target.result);
    };
    reader.readAsText(file);
  }, false);
}

function stopFormBrowserDefault(event) {
  $(".article-admin-form").bind(event, function(e) { e.preventDefault(); });
}

function fillForm(data) {
  var content = data.split("\n");
  var header  = new Array();

  var i = 0;
  for (; i < content.length; ++i) {
    if (content[i].trim() == "") break;
    header.push(content.shift());
    --i;
  }

  if (i == content.length - 1) {
    content = header.join("\n");
  } else {
    $("#article_content").val(content.join("\n").trim());

    for (var i = 0; i < header.length; ++i) {
      attrs = header[i].match(/@([a-z]+):\s*(.*)/);
      if (attrs[1] == "tags")
        $("#article_tag_list").val(attrs[2]);
      else
        $("#article_" + attrs[1]).val(attrs[2]);
    }
  }
}
