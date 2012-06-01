EasyMailPreview = {
  mailerAndMethod: function() {
    return EasyMailPreview.selectedMailer() + '_' + EasyMailPreview.selectedMethod();
  },

  preview: function(evt) {
    url = EasyMailPreview.rootPath + "emails/show/";
    url += EasyMailPreview.mailerAndMethod();
    var argCount =
      $(EasyMailPreview.selectedMethodArgumentsSelector() + ' input').length;
    if (argCount > 0) {
      url += "?";
      for (var i = 0; i < argCount; i++) {
        evalString =
          $('input[name=mail_methods_' + EasyMailPreview.mailerAndMethod() + '_' + i + ']').val(); 
        if (i > 0) url += '&';
        url += "arg_" + i + "=" + escape(evalString);
      }
    }
    $('#preview_frame').attr('src', url);
    return false;
  },

  refreshSelections: function() {
     $('.mail_methods').hide();
     $('.mail_methods#mail_methods_' + EasyMailPreview.selectedMailer()).show();
     $('.arguments').hide();
     $(EasyMailPreview.selectedMethodArgumentsSelector()).show();
  },

  selectedMailer: function() {
    return $('form#email_preview select[name=mailer]').val();
  },

  selectedMethod: function() {
    return $('form#email_preview select[name=mail_method_' + EasyMailPreview.selectedMailer() + ']').val();
  },

  selectedMethodArgumentsSelector: function() {
    return '.arguments#mail_methods_' + EasyMailPreview.mailerAndMethod();
  }
};

$(document).ready(function() {
  EasyMailPreview.refreshSelections();
  
  $('form#email_preview select[name=mailer]')
      .live('change', EasyMailPreview.refreshSelections);
  $('form#email_preview .mail_methods select')
      .live('change', EasyMailPreview.refreshSelections);
  $('form#email_preview').submit(EasyMailPreview.preview);
});

