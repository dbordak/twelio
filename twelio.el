;;; twelio.el --- Twilio Client Library

;; Copyright (C) 2015 Daniel Bordak

;; Author: Daniel Bordak <dbordak@fastmail.fm>
;; URL: TODO
;; Version: 0.1
;; Package-Requires: ((request "0.2"))

;;; Commentary:
;;
;; todo maybe if i feel like it
;;

;;; Code:

(require 'cl-lib)
(require 'request)

(defgroup twelio nil
  "Twilio client library"
  :prefix "twelio-")

(defconst twelio-base-url "https://%s:%s@api.twilio.com/2010-04-01")

(defcustom twelio-account-sid nil
  "The account SID to use if not specified."
  :group 'twelio
  :type 'string)

(defcustom twelio-auth-token nil
  "The auth token to use if not specified."
  :group 'twelio
  :type 'string)

(cl-defun twelio-send-message (from to
                                    &key
                                    (sid twelio-account-sid)
                                    (message nil)
                                    (authtoken twelio-auth-token))
  "Send MESSAGE from FROM as an SMS or MMS to TO.
Uses SID if given, otherwise uses twelio-account-sid.
If no MESSAGE is given, sends the current buffer."
  (request
   (format "%s/Accounts/%s/Messages"
           (format twelio-base-url sid authtoken) sid)
   :type "POST"
   :parser 'json-read
   :files (when (not message)
            `(("Body" . ,(current-buffer))))
   :data `(("To" . ,to)
           ("From" . ,from)
           ,(when message
              (cons "Body" message)))))

(provide 'twelio)

;;; twelio.el ends here
