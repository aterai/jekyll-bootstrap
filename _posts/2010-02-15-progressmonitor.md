---
layout: post
title: ProgressMonitorで処理の進捗を表示
category: swing
folder: ProgressMonitor
tags: [ProgressMonitor, SwingWorker, PropertyChangeListener, JProgressBar]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-02-15

## ProgressMonitorで処理の進捗を表示
`ProgressMonitor`で処理の進捗を表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh6.ggpht.com/_9Z4BYR88imo/TQTRQXIAu4I/AAAAAAAAAg4/bh8niw_k5AE/s800/ProgressMonitor.png)

### サンプルコード
<pre class="prettyprint"><code>final ProgressMonitor monitor = new ProgressMonitor(this, "message", "note", 0, 100);
monitor.setProgress(0);
worker = new SwingWorker&lt;String, String&gt;() {
  @Override public String doInBackground() {
    int current = 0;
    int lengthOfTask = 120; //list.size();
    while(current&lt;lengthOfTask &amp;&amp; !isCancelled()) {
    //while(current&lt;lengthOfTask &amp;&amp; !monitor.isCanceled()) {
      try {
        Thread.sleep(50);
      }catch(InterruptedException ie) {
        return "Interrupted";
      }
      setProgress(100 * current / lengthOfTask);
      publish(current + "/" + lengthOfTask);
      current++;
    }
    return "Done";
  }
  @Override protected void process(java.util.List&lt;String&gt; chunks) {
    for(String message : chunks) {
      monitor.setNote(message);
    }
  }
  @Override public void done() {
    runButton.setEnabled(true);
    monitor.close();
    String text = null;
    if(isCancelled()) {
      text = "Cancelled";
    }else{
      try {
        text = get();
      }catch(Exception ex) {
        ex.printStackTrace();
        text = "Exception";
      }
    }
    //System.out.println(text);
    area.append(text+"\n");
    area.setCaretPosition(area.getDocument().getLength());
    //appendLine(text);
  }
};
worker.addPropertyChangeListener(new ProgressListener(monitor));
worker.execute();
</code></pre>

### 解説
上記のサンプルでは、`SwingWorker`を使ったタスクの進捗状態を`ProgressMonitor`で表示しています。

- - - -
`ProgressListener`は、`Tutorial`の[ProgressMonitorDemo.java](http://docs.oracle.com/javase/tutorial/uiswing/examples/components/ProgressMonitorDemoProject/src/components/ProgressMonitorDemo.java)を変更して使用しています。

<pre class="prettyprint"><code>class ProgressListener implements PropertyChangeListener {
  private final ProgressMonitor monitor;
  public ProgressListener(ProgressMonitor monitor) {
    this.monitor = monitor;
    this.monitor.setProgress(0);
  }
  @Override public void propertyChange(PropertyChangeEvent e) {
    String strPropertyName = e.getPropertyName();
    if("progress".equals(strPropertyName)) {
      monitor.setProgress((Integer)e.getNewValue());
      if(monitor.isCanceled()) {
        ((SwingWorker)e.getSource()).cancel(true);
      }
    }
  }
}
</code></pre>

### 参考リンク
- [How to Use Progress Bars (The Java™ Tutorials)](http://docs.oracle.com/javase/tutorial/uiswing/components/progress.html)
- [ProgressMonitorがダイアログを表示までの待ち時間](http://terai.xrea.jp/Swing/MillisToDecideToPopup.html)

<!-- dummy comment line for breaking list -->

### コメント