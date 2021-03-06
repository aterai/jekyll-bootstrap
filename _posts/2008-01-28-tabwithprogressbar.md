---
layout: post
category: swing
folder: TabWithProgressBar
title: JTabbedPaneのタブにJProgressBarを表示
tags: [JTabbedPane, JProgressBar, SwingWorker]
author: aterai
pubdate: 2008-01-28T12:53:45+09:00
description: JTabbedPaneのタブにJProgressBarを配置して、進捗を表示します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTVHzMYZuI/AAAAAAAAAnI/7G4e4YZbiAQ/s800/TabWithProgressBar.png
comments: true
---
## 概要
`JTabbedPane`のタブに`JProgressBar`を配置して、進捗を表示します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTVHzMYZuI/AAAAAAAAAnI/7G4e4YZbiAQ/s800/TabWithProgressBar.png %}

## サンプルコード
<pre class="prettyprint"><code>private final Executor executor = Executors.newCachedThreadPool();
public void addTab(String title, final Component content) {
  super.addTab(title, new JLabel("Loading..."));
  final JProgressBar bar = new JProgressBar();
  final int currentIndex = getTabCount() - 1;
  final JLabel label = new JLabel(title);
  Dimension dim = label.getPreferredSize();
  int w = Math.max(80, dim.width);
  label.setPreferredSize(new Dimension(w, dim.height));
  Insets tabInsets = UIManager.getInsets("TabbedPane.tabInsets");
  bar.setPreferredSize(new Dimension(w, dim.height - tabInsets.top - 1));
  setTabComponentAt(currentIndex, bar);
  SwingWorker worker = new SwingWorker() {
    @Override public Object doInBackground() {
      int current = 0;
      int lengthOfTask = 180;
      while (current &lt; lengthOfTask) {
        if (!bar.isDisplayable()) return "NotDisplayable";
        try {
          Thread.sleep(25);
        } catch (InterruptedException ie) {
          return "Interrupted";
        }
        current++;
        setProgress(100 * current / lengthOfTask);
      }
      return "Done";
    }

    @Override public void done() {
      setTabComponentAt(currentIndex, label);
      setComponentAt(currentIndex, content);
    }
  };
  worker.addPropertyChangeListener(new ProgressListener(bar));
  executor.execute(worker); // JDK 1.6.0_18
  // worker.execute();
}
</code></pre>

## 解説
上記のサンプルでは、`JDK 6`で追加された`JTabbedPane`のタブにコンポーネントを配置する機能を使用して、`JProgressBar`をタブ内に追加し、コンテナ読込みの進捗状況を表示しています。

- `JProgressBar`の追加と同時に`SwingWorker#execute()`で進捗状況表示をスタート
- 処理が終了して`SwingWorker#done()`が実行されたら対象タブの`JProgressBar`を`JLabel`で入れ替え

<!-- dummy comment line for breaking list -->

## 参考リンク
- [SwingWorkerを使った処理の中断と進捗状況表示](https://ateraimemo.com/Swing/SwingWorker.html)
- [JTabbedPaneにタブを閉じるボタンを追加](https://ateraimemo.com/Swing/TabWithCloseButton.html)

<!-- dummy comment line for breaking list -->

## コメント
