describe Fastlane::Actions::ReqxAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The reqx plugin is working!")

      Fastlane::Actions::ReqxAction.run(nil)
    end
  end
end
