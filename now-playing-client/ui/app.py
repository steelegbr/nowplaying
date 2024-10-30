from kivy.app import App
from ui.view import HomeView


class NowPlayingApp(App):
    def build(self):
        return HomeView()
