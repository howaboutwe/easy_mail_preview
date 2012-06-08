EasyMailPreview
===============

EasyMailPreview is a Rails tool that makes it easy to get previews of
your HTML emails in development. It is designed to offer as much power
as possible with a minimum of configuration.  

Inspired in part by RailsEmailPreview:
  https://github.com/glebm/rails_email_preview

Security Note
-------------

EasyMailPreview is only intended to be used in development mode. The
instructions below tell you how to do that. You really shouldn't run it
in any other mode.

If you care about the details: To save you the trouble of having to
create factory methods for emails you'd like to preview, EasyMailPreview
takes Ruby strings as arguments in HTTP GET requests and eval's them
inside of the Rails server. If you were to expose this in a publically
available site it would be trivially easy for somebody else to use it to
destroy your data. Please don't do that.

Usage
-----

1. Include the Gem in your Gemfile:

    gem 'easy_mail_preview'

2. Specify which mailer classes you'd like to use for previewing in
   `config/initializers/easy_mail_preview`:

    require 'easy_mail_preview'

    EasyMailPreview.setup do |config|
      config.mailers = [
        MessageMailer, LifecycleMailer, ExpirationMailer
      ]
    end
  
3. Mount the app in `config/routes`. *Important*: you should only do this in
   development mode.

    if Rails.env.development?
      mount EasyMailPreview::Engine, :at => 'email_previews'
    end
  
4. Start up your Rails server and go to your URL:

    http://localhost:3000/email_previews

That's it! You will be able to select mailer classes, mail methods, and
then fill in arguments to pass to the mail method.

Copyright
---------

Copyright (c) 2012 HowAboutWe. See MIT-LICENSE for further details.
