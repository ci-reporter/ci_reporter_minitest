require 'rexml/document'
require 'rspec/collection_matchers'
require 'ci/reporter/test_utils/accessor'
require 'ci/reporter/test_utils/shared_examples'

REPORTS_DIR = File.dirname(__FILE__) + '/reports'

describe "MiniTest::Unit acceptance" do
  include CI::Reporter::TestUtils::SharedExamples
  Accessor = CI::Reporter::TestUtils::Accessor

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

  def load_xml_result(path)
    File.open(path) do |f|
      REXML::Document.new(f)
    end
  end
end
