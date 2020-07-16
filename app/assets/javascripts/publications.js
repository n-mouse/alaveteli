function remove_fields(link) {
	$(link).prev("input[type=hidden]").val("1");
        $(link).closest(".gallery-inputs").hide();
}
function add_fields(link, association, content) {
	var new_id = new Date().getTime();
	var regexp = new RegExp("new_" + association, "g");
	$(link).parent().before(content.replace(regexp, new_id));
}

$("document:ready", function() {
	$("[rel=tinymce]").tinymce({
		theme: "modern",
		toolbar: "bold,italic,underline,|,bullist,numlist,outdent,indent,|,undo,redo,|,pastetext,pasteword,selectall,|,uploadimage, image, link, code",
		pagebreak_separator: "<p class='page-separator'>&nbsp;</p>",
		plugins: ["uploadimage", "link", "code", "image"],
		relative_urls: false,
		remove_script_host: false
  	})

});
