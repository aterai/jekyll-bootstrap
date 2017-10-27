---
layout: post
category: swing
folder: ProgressMonitor
title: ProgressMonitorで処理の進捗を表示
tags: [ProgressMonitor, SwingWorker, PropertyChangeListener, JProgressBar]
author: aterai
pubdate: 2010-02-15T14:18:06+09:00
description: ProgressMonitorで処理の進捗を表示します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTRQXIAu4I/AAAAAAAAAg4/bh8niw_k5AE/s800/ProgressMonitor.png
comments: true
---
## 概要
`ProgressMonitor`で処理の進捗を表示します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTRQXIAu4I/AAAAAAAAAg4/bh8niw_k5AE/s800/ProgressMonitor.png %}

## サンプルコード
<pre class="prettyprint"><code>final ProgressMonitor monitor = new ProgressMonitor(
    this, "message", "note", 0, 100);
monitor.setProgress(0);
worker = new SwingWorker&lt;String, String&gt;() {
  @Override public String doInBackground() {
    int current = 0;
    int lengthOfTask = 120; //list.size();
    while (current &lt; lengthOfTask &amp;&amp; !isCancelled()) {
      try {
        Thread.sleep(50);
      } catch (InterruptedException ie) {
        return "Interrupted";
      }
      setProgress(100 * current / lengthOfTask);
      publish(current + "/" + lengthOfTask);
      current++;
    }
    return "Done";
  }
  @Override protected void process(java.util.List&lt;String&gt; chunks) {
    for (String message : chunks) {
      monitor.setNote(message);
    }
  }
  @Override public void done() {
    runButton.setEnabled(true);
    monitor.close();
    String text = null;
    if (isCancelled()) {
      text = "Cancelled";
    } else {
      try {
        text = get();
      } catch (Exception ex) {
        ex.printStackTrace();
        text = "Exception";
      }
    }
    //System.out.println(text);
    area.append(text + "\n");
    area.setCaretPosition(area.getDocument().getLength());
    //appendLine(text);
  }
};
worker.addPropertyChangeListener(new ProgressListener(monitor));
worker.execute();
</code></pre>

## 解説
上記のサンプルでは、`SwingWorker`を使ったタスクの進捗状態を`ProgressMonitor`で表示しています。

- - - -
`ProgressListener`は、`Tutorial`の[ProgressMonitorDemo.java](https://docs.oracle.com/javase/tutorial/uiswing/examples/components/ProgressMonitorDemoProject/src/components/ProgressMonitorDemo.java)を変更して使用しています。

<pre class="prettyprint"><code>class ProgressListener implements PropertyChangeListener {
  private final ProgressMonitor monitor;
  public ProgressListener(ProgressMonitor monitor) {
    this.monitor = monitor;
    this.monitor.setProgress(0);
  }
  @Override public void propertyChange(PropertyChangeEvent e) {
    Object o = e.getSource();
    String strPropertyName = e.getPropertyName();
    if ("progress".equals(strPropertyName) &amp;&amp; o instanceof SwingWorker) {
      SwingWorker task = (SwingWorker) o;
      monitor.setProgress((Integer) e.getNewValue());
      if (monitor.isCanceled() || task.isDone()) {
        task.cancel(true);
      }
    }
  }
}
</code></pre>

## 参考リンク
- [ProgressMonitor (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/ProgressMonitor.html)
- [How to Use Progress Bars (The Java™ Tutorials)](https://docs.oracle.com/javase/tutorial/uiswing/components/progress.html)
- [ProgressMonitorがダイアログを表示するまでの待ち時間](https://ateraimemo.com/Swing/MillisToDecideToPopup.html)
    - 処理時間が短くて`ProgressMonitor`が表示されない場合の待ち時間をテスト

<!-- dummy comment line for breaking list -->

## コメント
