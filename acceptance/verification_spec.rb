require 'rexml/document'

REPORTS_DIR = File.dirname(__FILE__) + '/reports'

describe "MiniTest::Unit acceptance" do
  let(:failure_report_path) { File.join(REPORTS_DIR, 'TEST-ExampleWithAFailure.xml') }
  let(:error_report_path)   { File.join(REPORTS_DIR, 'TEST-ExampleWithAnError.xml') }
  let(:passing_report_path) { File.join(REPORTS_DIR, 'TEST-ExampleThatPasses.xml') }
  let(:output_report_path)  { File.join(REPORTS_DIR, 'TEST-ExampleWithOutput.xml') }

  context "generated files" do
    it "generates XML files for each class" do
      pending "A rogue file is created"
      expect(Dir["#{REPORTS_DIR}/*.xml"].count).to eql 4
    end

    it "generates XML for the failing test" do
      expect(File.exist?(failure_report_path)).to be true
    end

    it "generates XML for the errored test" do
      expect(File.exist?(error_report_path)).to be true
    end

    it "generates XML for the passing test" do
      expect(File.exist?(passing_report_path)).to be true
    end

    it "generates XML for the output capturing test" do
      expect(File.exist?(output_report_path)).to be true
    end
  end

  context "a test with a failure" do
    let (:root) { load_xml_result(failure_report_path).root }

    it "has one failure" do
      expect(root.attributes["failures"]).to eql "1"
    end

    it "has zero errors" do
      expect(root.attributes["errors"]).to eql "0"
    end

    it "has one assertion" do
      expect(root.attributes["assertions"]).to eql "1"
    end

    it "has one test" do
      expect(root.attributes["tests"]).to eql "1"
    end

    it "has one testcase" do
      expect(root.elements.to_a("/testsuite/testcase").size).to eql 1
    end

    context "the testcase" do
      it "has a failure" do
        expect(root.elements.to_a("/testsuite/testcase/failure").size).to eql 1
      end

      it "has no errors" do
        expect(root.elements.to_a("/testsuite/testcase/error").size).to eql 0
      end
    end
  end

  context "a test with an error" do
    let (:root) { load_xml_result(error_report_path).root }

    it "has zero failures" do
      expect(root.attributes["failures"]).to eql "0"
    end

    it "has an error" do
      expect(root.attributes["errors"]).to eql "1"
    end

    it "has no assertions" do
      expect(root.attributes["assertions"]).to eql "0"
    end

    it "has one test" do
      expect(root.attributes["tests"]).to eql "1"
    end

    it "has one testcase" do
      expect(root.elements.to_a("/testsuite/testcase").size).to eql 1
    end

    context "the testcase" do
      it "has no failures" do
        expect(root.elements.to_a("/testsuite/testcase/failure").size).to eql 0
      end

      it "has an error" do
        expect(root.elements.to_a("/testsuite/testcase/error").size).to eql 1
      end
    end
  end

  context "a test that outputs to STDOUT and STDERR" do
    let (:root) { load_xml_result(output_report_path).root }

    it "captures the STDOUT" do
      content = root.elements.to_a("/testsuite/system-out").first.texts.inject("") do |c,e|
        c << e.value; c
      end.strip

      expect(content).to eql "This is stdout!"
    end

    it "captures the STDERR" do
      content = root.elements.to_a("/testsuite/system-err").first.texts.inject("") do |c,e|
        c << e.value; c
      end.strip

      expect(content).to eql "This is stderr!"
    end
  end

  context "a passing test" do
    let(:root) { load_xml_result(passing_report_path).root }

    it "has zero errors" do
      expect(root.attributes["errors"]).to eql "0"
    end

    it "has zero failures" do
      expect(root.attributes["failures"]).to eql "0"
    end

    it "has one assertion" do
      expect(root.attributes["assertions"]).to eql "1"
    end

    it "has one test" do
      expect(root.attributes["tests"]).to eql "1"
    end

    it "has one testcase" do
      expect(root.elements.to_a("/testsuite/testcase").size).to eql 1
    end

    context "the testcase" do
      it "has no failures" do
        expect(root.elements.to_a("/testsuite/testcase/failure").size).to eql 0
      end

      it "has no errors" do
        expect(root.elements.to_a("/testsuite/testcase/error").size).to eql 0
      end
    end
  end

  def load_xml_result(path)
    File.open(path) do |f|
      REXML::Document.new(f)
    end
  end
end
