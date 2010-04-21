class EmailTemplate < ActiveRecord::Base

  belongs_to :farm
  ### Validation
  validates_presence_of :subject, :from, :body, :name

  # http://code.dunae.ca/validates_email_format_of.html
  validates_email_format_of :from, :allow_nil => true, :allow_blank => true
  validates_email_format_of :cc, :allow_nil => true, :allow_blank => true
  validates_email_format_of :bcc, :allow_nil => true, :allow_blank => true

  validate :body_must_be_valid_liquid_format, :subject_must_be_valid_liquid_format


  #
  # Puts the parse error from Liquid on the error list if parsing failed
  #
  def body_must_be_valid_liquid_format
    errors.add :body, @syntax_error unless @syntax_error.nil?
  end

  def subject_must_be_valid_liquid_format
    errors.add :subject, @subject_syntax_error unless @subject_syntax_error.nil?
  end

  ### Attributes
  attr_protected :template

  #
  # body contains the raw template. When updating this attribute, the
  # email_template parses the template and stores the serialized object
  # for quicker rendering.
  #
  def body=(text)
    self[:body] = text

    begin
      @template = Liquid::Template.parse(text)
      self[:template] = ActiveSupport::Base64.encode64(Marshal.dump(@template))
    rescue Liquid::SyntaxError => error
      @syntax_error = error.message
    end
  end

  def subject=(text)
    self[:subject] = text

    begin
      @subject_template = Liquid::Template.parse(text)
    rescue Liquid::SyntaxError => error
      @subject_syntax_error = error.message
    end
  end

  ### Methods

  #
  # Delivers the email
  #
  def deliver_to(address, options = {})
    puts "deliver_to"
    options[:cc] ||= cc unless cc.blank?
    options[:bcc] ||= bcc unless bcc.blank?

    # Liquid doesn't like symbols as keys
    options.stringify_keys!
    ApplicationMailer.deliver_email_template(address, self, options)
  end

  #
  # Renders body as Liquid Markup template
  #
  def render_body(options = {})
    puts template.render options
    template.render options
  end

  def render_subject(options = {})
    subject_template.render options
  end

  #
  # Usable string representation
  #
  def to_s
    "[EmailTemplate] From: #{from}, '#{subject}': #{body}"
  end

 private
  #
  # Returns a usable Liquid:Template instance
  #
  def template
    return @template unless @template.nil?

    if self[:template].blank?
      @template = Liquid::Template.parse body
      self[:template] = ActiveSupport::Base64.encode64(@template)
      save
    else
      @template = Marshal.load ActiveSupport::Base64.decode64(self[:template])
    end

    @template
  end

  def subject_template
    return @subject_template unless @subject_template.nil?

    @subject_template = Liquid::Template.parse subject
    @subject_template
  end

end
