import gi
import json
import os
import sys
from datetime import datetime

gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, Gdk, GLib

TODO_FILE = os.path.expanduser("~/.config/waybar/todo.json")

class TodoApp(Gtk.Window):
    def __init__(self):
        super().__init__(title="Minimalist To-Do")
        self.set_name("todo-window")
        self.set_wmclass("waybar-todo", "waybar-todo")
        self.set_default_size(350, 400)
        self.set_position(Gtk.WindowPosition.CENTER)
        self.set_border_width(15)

        # Visuals: Force transparency
        screen = self.get_screen()
        visual = screen.get_rgba_visual()
        if visual and self.is_composited():
            self.set_visual(visual)
        self.set_app_paintable(True)

        # Apply CSS for deep transparency and consistent theme
        style_provider = Gtk.CssProvider()
        style_provider.load_from_data(b"""
            * {
                font-family: 'MesloLGS Nerd Font';
                font-size: 13px;
                background-color: transparent;
            }
            window {
                background-color: rgba(0, 0, 0, 0.75);
                color: #F2E4DA;
                border: 2px solid #AFA79D;
                border-radius: 18px;
            }
            scrolledwindow, listbox, row {
                background-color: transparent;
                border: none;
            }
            .task-row {
                background: rgba(255, 255, 255, 0.08);
                margin: 5px;
                padding: 10px;
                border-radius: 12px;
            }
            .task-time {
                font-size: 10px;
                color: rgba(242, 228, 218, 0.5);
                margin: 0 10px;
            }
            entry {
                background: rgba(255, 255, 255, 0.1);
                border: none;
                border-radius: 10px;
                padding: 10px;
                color: #F2E4DA;
                margin-bottom: 15px;
            }
            button.delete-btn {
                background: transparent;
                color: #eb4d4b;
                border-radius: 8px;
                padding: 2px 8px;
            }
            button.delete-btn:hover {
                background: rgba(235, 77, 75, 0.2);
            }
            checkbutton {
                color: #F2E4DA;
            }
        """)
        Gtk.StyleContext.add_provider_for_screen(
            Gdk.Screen.get_default(),
            style_provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

        self.tasks = self.load_tasks()

        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        self.add(vbox)

        # Entry for new tasks
        self.entry = Gtk.Entry(placeholder_text="Add a new task...")
        self.entry.connect("activate", self.on_add_task)
        vbox.pack_start(self.entry, False, False, 0)

        # Scrolled Window for list
        scrolled = Gtk.ScrolledWindow()
        scrolled.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        vbox.pack_start(scrolled, True, True, 0)

        self.listbox = Gtk.ListBox()
        self.listbox.set_selection_mode(Gtk.SelectionMode.NONE)
        scrolled.add(self.listbox)

        self.refresh_list()
        self.show_all()

    def load_tasks(self):
        if os.path.exists(TODO_FILE):
            try:
                with open(TODO_FILE, 'r') as f:
                    return json.load(f)
            except:
                return []
        return []

    def save_tasks(self):
        with open(TODO_FILE, 'w') as f:
            json.dump(self.tasks, f)

    def on_add_task(self, entry):
        text = entry.get_text().strip()
        if text:
            now = datetime.now().strftime("%d/%m %I:%M %p")
            self.tasks.append({"text": text, "done": False, "created_at": now})
            entry.set_text("")
            self.save_tasks()
            self.refresh_list()

    def refresh_list(self):
        for child in self.listbox.get_children():
            self.listbox.remove(child)

        for i, task in enumerate(self.tasks):
            row = Gtk.ListBoxRow()
            row.set_name(f"task-{i}")
            hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
            hbox.get_style_context().add_class("task-row")
            row.add(hbox)

            # Checkbox
            check = Gtk.CheckButton()
            check.set_active(task["done"])
            check.connect("toggled", self.on_toggle_done, i)
            hbox.pack_start(check, False, False, 0)

            # Label
            label = Gtk.Label()
            label.set_xalign(0)
            if task["done"]:
                label.set_markup(f"<s>{task['text']}</s>")
            else:
                label.set_text(task["text"])
            hbox.pack_start(label, True, True, 0)

            # Time Label
            time_str = task.get("created_at", "")
            time_label = Gtk.Label(label=time_str)
            time_label.get_style_context().add_class("task-time")
            hbox.pack_start(time_label, False, False, 0)

            # Delete Button
            del_btn = Gtk.Button(label="")
            del_btn.get_style_context().add_class("delete-btn")
            del_btn.connect("clicked", self.on_delete_task, i)
            hbox.pack_start(del_btn, False, False, 0)

            self.listbox.add(row)
        
        self.show_all()

    def on_toggle_done(self, check, index):
        self.tasks[index]["done"] = check.get_active()
        self.save_tasks()
        self.refresh_list()

    def on_delete_task(self, btn, index):
        del self.tasks[index]
        self.save_tasks()
        self.refresh_list()

if __name__ == "__main__":
    app = TodoApp()
    app.connect("destroy", Gtk.main_quit)
    Gtk.main()
