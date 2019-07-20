#pragma once

#include <deque>
#include <qt/QtCore/QEvent>
#include <qt/QtCore/QProcess>
#include <qt/QtCore/QTimer>
#include <qt/QtCore/Qt>
#include <qt/QtGui/QScreen>
#include <qt/QtWidgets/QApplication>
#include <qt/QtWebKitWidgets/QWebView>
#include <statusbar/EventFilter.h>

namespace statusbar {

inline auto main(
	int argc,
	char **argv
) -> int {
	auto application = QApplication {argc, argv};

	auto windows = std::deque<QWebView> {};

	auto window_event_filter = EventFilter {[&] (auto object, auto event) {
		switch (event->type()) {
			case QEvent::Close: {
				for (auto & window : windows) {
					if (object == (& window)) {
						QApplication::quit();
						break;
					}
				}

				return false;
			}
			default: {
				return false;
			}
		}
	}};

	auto update_windows = [&] () {
		windows.clear();

		auto screens = application.screens();

		for (auto screen : screens) {
			windows.emplace_back();

			auto & window = windows.back();

			window.move(screen->geometry().x(), screen->geometry().y());
			window.setFixedWidth(screen->geometry().width());
			window.setFixedHeight(24);
			window.setWindowFlags(
				Qt::FramelessWindowHint |
				Qt::X11BypassWindowManagerHint
			);
			window.installEventFilter(& window_event_filter);
			window.show();
		}
	};

	update_windows();

	QObject::connect(& application, & QGuiApplication::screenAdded, [&] (auto) {
		update_windows();
	});

	QObject::connect(& application, & QGuiApplication::screenRemoved, [&] (auto) {
		update_windows();
	});

	auto process = QProcess {};

	auto html = QByteArray {};

	auto update_state = [&] () {
		process.~QProcess();

		new(& process) QProcess {};

		QObject::connect(
			& process,
			static_cast<void (QProcess::*)(int, QProcess::ExitStatus)>(& QProcess::finished),
			[&] (int, QProcess::ExitStatus) {
				auto output = process.readAllStandardOutput();

				if (html == output) {
					return;
				}

				html = output;

				for (auto & window : windows) {
					window.setHtml(html);
				}
			}
		);

		process.setProgram("status.sh");
		process.start();
	};

	update_state();

	auto timer = QTimer {};

	QObject::connect(& timer, & QTimer::timeout, update_state);

	timer.setInterval(1000);
	timer.start();

	return application.exec();
}

}
