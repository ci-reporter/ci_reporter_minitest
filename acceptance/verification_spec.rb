require 'rexml/document'
require 'rspec/collection_matchers'

REPORTS_DIR = File.dirname(__FILE__) + '/reports'

shared_examples "nothing was output" do
  describe "stdout" do
    subject { result.system_out }
    it { is_expected.to be_empty }
  end

  describe "stderr" do
    subject { result.system_err }
    it { is_expected.to be_empty }
  end
end

shared_examples "a report with consistent attribute counts" do
  describe "the failure count" do
    subject { result.failures_count }
    it { is_expected.to eql result.failures.count }
  end

  describe "the error count" do
    subject { result.errors_count }
    it { is_expected.to eql result.errors.count }
  end

  describe "the test count" do
    subject { result.tests_count }
    it { is_expected.to eql result.testcases.count }
  end
end

describe "MiniTest::Unit acceptance" do
  let(:failure_report_path) { File.join(REPORTS_DIR, 'TEST-ExampleWithAFailure.xml') }
  let(:error_report_path)   { File.join(REPORTS_DIR, 'TEST-ExampleWithAnError.xml') }
  let(:passing_report_path) { File.join(REPORTS_DIR, 'TEST-ExampleThatPasses.xml') }
  let(:output_report_path)  { File.join(REPORTS_DIR, 'TEST-ExampleWithOutput.xml') }

  it "generates only one XML file for each test class" do
    expect(Dir["#{REPORTS_DIR}/*.xml"].count).to eql 4
  end

  context "a test with a failure" do
    subject(:result) { Accessor.new(load_xml_result(failure_report_path)) }

    it { is_expected.to have(1).failures }
    it { is_expected.to have(0).errors }
    it { is_expected.to have(1).testcases }

    describe "the assertion count" do
      subject { result.assertions_count }
      it { is_expected.to eql 1 }
    end

    it_behaves_like "nothing was output"
    it_behaves_like "a report with consistent attribute counts"
  end

  context "a test with an error" do
    subject(:result) { Accessor.new(load_xml_result(error_report_path)) }

    it { is_expected.to have(0).failures }
    it { is_expected.to have(1).errors }
    it { is_expected.to have(1).testcases }

    describe "the assertion count" do
      subject { result.assertions_count }
      it { is_expected.to eql 0 }
    end

    it_behaves_like "nothing was output"
    it_behaves_like "a report with consistent attribute counts"
  end

  context "a test that outputs to STDOUT and STDERR" do
    subject(:result) { Accessor.new(load_xml_result(output_report_path)) }

    it "captures the STDOUT" do
      expect(result.system_out).to eql "This is stdout!"
    end

    it "captures the STDERR" do
      expect(result.system_err).to eql "This is stderr!"
    end
  end

  context "a passing test" do
    subject(:result) { Accessor.new(load_xml_result(passing_report_path)) }

    it { is_expected.to have(0).failures }
    it { is_expected.to have(0).errors }
    it { is_expected.to have(1).testcases }

    describe "the assertion count" do
      subject { result.assertions_count }
      it { is_expected.to eql 1 }
    end

    it_behaves_like "nothing was output"
    it_behaves_like "a report with consistent attribute counts"
  end

  class Accessor
    attr_reader :root

    def initialize(xml)
      @root = xml.root
    end

    def failures
      root.elements.to_a("/testsuite/testcase/failure")
    end

    def errors
      root.elements.to_a("/testsuite/testcase/error")
    end

    def testcases
      root.elements.to_a("/testsuite/testcase")
    end

    [:failures, :errors, :assertions, :tests].each do |attr|
      define_method "#{attr}_count" do
        root.attributes[attr.to_s].to_i
      end
    end

    def system_out
      all_text_nodes_as_string("/testsuite/system-out")
    end

    def system_err
      all_text_nodes_as_string("/testsuite/system-err")
    end

    private

    def all_text_nodes_as_string(xpath)
      root.elements.to_a(xpath).map(&:texts).flatten.map(&:value).join.strip
    end
  end

  def load_xml_result(path)
    File.open(path) do |f|
      REXML::Document.new(f)
    end
  end
end
