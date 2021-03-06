---
layout: post
category: swing
folder: WatchingDirectoryTable
title: JTableに指定したディレクトリへのファイル追加、削除などを表示する
tags: [JTable, File, WatchService, SecondaryLoop]
author: aterai
pubdate: 2019-01-07T15:06:47+09:00
description: WatchServiceを使用してディレクトリの変更を監視し、ファイルの追加削除をJTableに表示します。
image: https://drive.google.com/uc?id=1zVO0YYMG8diggVHo4BHTANeWATFiL90StA
comments: true
---
## 概要
`WatchService`を使用してディレクトリの変更を監視し、ファイルの追加削除を`JTable`に表示します。

{% download https://drive.google.com/uc?id=1zVO0YYMG8diggVHo4BHTANeWATFiL90StA %}

## サンプルコード
<pre class="prettyprint"><code>Path dir = Paths.get(System.getProperty("java.io.tmpdir"));
SecondaryLoop loop = Toolkit.getDefaultToolkit().getSystemEventQueue().createSecondaryLoop();
Thread worker = new Thread(() -&gt; {
  try (WatchService watcher = FileSystems.getDefault().newWatchService()) {
    dir.register(watcher,
        StandardWatchEventKinds.ENTRY_CREATE,
        StandardWatchEventKinds.ENTRY_DELETE);
    append("register: " + dir);
    processEvents(dir, watcher);
    loop.exit();
  } catch (IOException ex) {
    throw new UncheckedIOException(ex);
  }
});
worker.start();
if (!loop.enter()) {
  append("Error");
}

// Watching a Directory for Changes (The Java™ Tutorials &gt; Essential Classes &gt; Basic I/O)
// https://docs.oracle.com/javase/tutorial/essential/io/notification.html
// Process all events for keys queued to the watcher
public void processEvents(Path dir, WatchService watcher) {
  for (;;) {
    // wait for key to be signaled
    WatchKey key;
    try {
      key = watcher.take();
    } catch (InterruptedException ex) {
      EventQueue.invokeLater(() -&gt; append("Interrupted"));
      return;
    }

    for (WatchEvent&lt;?&gt; event: key.pollEvents()) {
      WatchEvent.Kind&lt;?&gt; kind = event.kind();

      // This key is registered only for ENTRY_CREATE events,
      // but an OVERFLOW event can occur regardless if events
      // are lost or discarded.
      if (kind == StandardWatchEventKinds.OVERFLOW) {
        continue;
      }

      // The filename is the context of the event.
      @SuppressWarnings("unchecked")
      WatchEvent&lt;Path&gt; ev = (WatchEvent&lt;Path&gt;) event;
      Path filename = ev.context();

      Path child = dir.resolve(filename);
      EventQueue.invokeLater(() -&gt; {
        append(String.format("%s: %s", kind, child));
        updateTable(kind, child);
      });
    }

    // Reset the key -- this step is critical if you want to
    // receive further watch events.  If the key is no longer valid,
    // the directory is inaccessible so exit the loop.
    boolean valid = key.reset();
    if (!valid) {
      break;
    }
  }
}

public void updateTable(WatchEvent.Kind&lt;?&gt; kind, Path child) {
  if (kind == StandardWatchEventKinds.ENTRY_CREATE) {
    model.addPath(child);
  } else if (kind == StandardWatchEventKinds.ENTRY_DELETE) {
    for (int i = 0; i &lt; model.getRowCount(); i++) {
      Object value = model.getValueAt(i, 2);
      String path = Objects.toString(value, "");
      if (path.equals(child.toString())) {
        deleteRowSet.add(i);
        // model.removeRow(i);
        break;
      }
    }
    sorter.setRowFilter(new RowFilter&lt;TableModel, Integer&gt;() {
      @Override
      public boolean include(Entry&lt;? extends TableModel, ? extends Integer&gt; entry) {
        return !deleteRowSet.contains(entry.getIdentifier());
      }
    });
  }
}
</code></pre>

## 解説
上記のサンプルでは、`SecondaryLoop`で作成した`EDT`とは別のスレッドで`WatchService`を起動し、`System.getProperty("java.io.tmpdir")`で取得した一時ディレクトリの変更を監視しています。

- `createTempFile`ボタンで一時ファイルを作成した場合:
    - `WatchService`で更新を取得し、`StandardWatchEventKinds.ENTRY_CREATE`の場合は`JTable`に`Path`を行として追加
- `JTable`に表示されている一時ファイルを表す行が`JPopupMenu`から削除された場合:
    - `Files.delete(...)`メソッドで一時ディレクトリから削除
        - この段階では`JTable`から行の削除は実行しない
    - `WatchService`で`StandardWatchEventKinds.ENTRY_DELETE`を検出したら`RowFilter`で削除された一時ファイルを表す行を非表示に設定
        - `DefaultTableModel#removeRow(...)`で削除すると例外が発生する場合がある？(再現できない？)
- 別アプリケーションで一時ファイルが削除された場合:
    - `WatchService`で`StandardWatchEventKinds.ENTRY_DELETE`を検出したら`RowFilter`で削除された一時ファイルを表す行を非表示に設定
- このサンプルアプリケーションを終了した場合:
    - `HierarchyListener`でパネルの破棄を検出したら、`WatchService`を使用しているスレッドに`interrupt()`メソッドで割り込み`InterruptedException`を発生
    - `InterruptedException`をキャッチしたら`WatchService`の監視ループを抜けて、`SecondaryLoop#exit()`メソッドを実行してセカンダリループも抜ける

<!-- dummy comment line for breaking list -->

## 参考リンク
[Watching a Directory for Changes (The Java™ Tutorials > Essential Classes > Basic I/O)](https://docs.oracle.com/javase/tutorial/essential/io/notification.html)

## コメント
