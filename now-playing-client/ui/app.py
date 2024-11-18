from kivy.app import App
from ui.views import HomeView


class NowPlayingApp(App):
    def build(self):
        return HomeView()
