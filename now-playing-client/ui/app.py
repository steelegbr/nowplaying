from kivy.app import App
from ui.views import HomeView


class NowPlayingApp(App):
    def build(self):
        self.title = "Now Playing"
        return HomeView()
