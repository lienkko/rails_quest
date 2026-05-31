class Quest3AccessGateController < ApplicationController
  # TODO: Add routes in config/routes.rb and finish the controller logic for Quest 3.
  # The quest expects a mix of GET / POST / PATCH / DELETE, conditional redirects,
  # and visible before_action / after_action callbacks.

  # Quest3DataService probes POST/PATCH/DELETE actions without a browser CSRF token.
  # Disable CSRF verification here so the probe can validate route/controller logic.
  skip_forgery_protection


  # Register callbacks here.

  before_action :prepare_clearance_sum, only: %i[clearance]
  after_action :set_clearance_trace, only: %i[clearance]

  before_action :extract_token, only: %i[granted]
  after_action :set_granted_trace, only: %i[granted]

  def ping
    render plain: "ACCESSGATE PING OK"
  end

  def scan
    agent = params[:agent].to_s
    sector = params[:sector].to_s

    render plain: "SCAN RESULT: #{agent} -> sector #{sector}"
  end

  def power
    current = params[:current].to_i
    boost = params[:boost].to_i

    render plain: "POWER TOTAL: #{current + boost}"
  end

  def stale_logs
    count = params[:count].to_s

    render plain: "STALE LOGS CLEARED: #{count}"
  end

  def clearance
    render plain: "CLEARANCE TOTAL: #{@clearance_total}"
  end

  def verify
    token = params[:token].to_s

    if token.start_with?("alpha")
      redirect_to granted_path(token: token)
    else
      redirect_to denied_path(token: token)
    end
  end

  def granted
    render plain: "TOKEN ACCEPTED: #{@token}"
  end

  def denied
    render plain: "TOKEN DENIED: #{params[:token].to_s}"
  end

  private


  # Implement callbacks here
  # response.set_header("X-Access-Gate-Trace", "") may be helpful
  def prepare_clearance_sum
    level = params[:level].to_i
    boost = params[:boost].to_i

    @clearance_total = level + boost
  end

  def set_clearance_trace
    response.set_header("X-Access-Gate-Trace", "CLEAREANCE_GRANTED")
  end

  def extract_token
    @token = params[:token].to_s
  end

  def set_granted_trace
    response.set_header("X-Access-Gate-Trace", "token_checked")
  end
end
