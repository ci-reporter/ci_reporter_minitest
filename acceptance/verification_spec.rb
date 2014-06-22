require 'rexml/document'

REPORTS_DIR = File.dirname(__FILE__) + '/reports'

describe "MiniTest::Unit acceptance" do
  let(:report_path_1) {File.join(REPORTS_DIR, 'TEST-MiniTestExampleTestOne.xml')}
  let(:report_path_2) {File.join(REPORTS_DIR, 'TEST-MiniTestExampleTestTwo.xml')}

  context "generated files" do
    it "generates two XML files" do
      pending "A rogue file is created"
      expect(Dir["#{REPORTS_DIR}/*.xml"].count).to eql 2
    end

    it "generates XML for the first test" do
      expect(File.exist?(report_path_1)).to be true
    end

    it "generates XML for the second test" do
      expect(File.exist?(report_path_2)).to be true
    end
  end

  context "a test with a failure and an error" do
    let (:root) { load_xml_result(report_path_1).root }

    it "has one error" do
      expect(root.attributes["errors"]).to eql "1"
    end

    it "has one failure" do
      expect(root.attributes["failures"]).to eql "1"
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
      it "has an error" do
        expect(root.elements.to_a("/testsuite/testcase/error").size).to eql 1
      end

      it "has a failure" do
        expect(root.elements.to_a("/testsuite/testcase/failure").size).to eql 1
      end
    end

    it "captures the STDOUT" do
      content = root.elements.to_a("/testsuite/system-out").first.texts.inject("") do |c,e|
        c << e.value; c
      end.strip

      expect(content).to eql "Some <![CDATA[on stdout]]>"
    end
  end

  context "a test without failures" do
    let(:root) { load_xml_result(report_path_2).root }

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
    end
  end

  def load_xml_result(path)
    File.open(path) do |f|
      REXML::Document.new(f)
    end
  end
end
