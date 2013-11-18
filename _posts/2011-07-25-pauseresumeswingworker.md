---
layout: post
title: SwingWorkerの一時停止と再開
category: swing
folder: PauseResumeSwingWorker
tags: [SwingWorker, JProgressBar, JTextArea]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-07-25

## SwingWorkerの一時停止と再開
`SwingWorker`で処理の一時停止と再開を行います。

{% download %}

![screenshot](https://lh6.googleusercontent.com/-3BCjKLnQbGM/Ti0AQV5nkwI/AAAAAAAAA_s/RY75ol3pFak/s800/PauseResumeSwingWorker.png)

### サンプルコード
<pre class="prettyprint"><code>class RunAction extends AbstractAction{
  public RunAction() {
    super("run");
  }
  @Override public void actionPerformed(ActionEvent evt) {
    final JProgressBar bar1 = new JProgressBar(0, 100);
    final JProgressBar bar2 = new JProgressBar(0, 100);
    runButton.setEnabled(false);
    canButton.setEnabled(true);
    pauseButton.setEnabled(true);
    statusPanel.removeAll();
    statusPanel.add(bar1, BorderLayout.NORTH);
    statusPanel.add(bar2, BorderLayout.SOUTH);
    statusPanel.revalidate();
    worker = new SwingWorker&lt;String, Progress&gt;() {
      @Override public String doInBackground() {
        int current = 0;
        int lengthOfTask = 12; //filelist.size();
        publish(new Progress(Component.LOG, "Length Of Task: " + lengthOfTask));
        publish(new Progress(Component.LOG, "\n---------------------------\n"));
        while(current&lt;lengthOfTask &amp;&amp; !isCancelled()) {
          publish(new Progress(Component.LOG, "*"));
          if(!bar1.isDisplayable()) {
            return "Disposed";
          }
          try{
            convertFileToSomething();
          }catch(InterruptedException ie) {
            return "Interrupted";
          }
          publish(new Progress(Component.TOTAL, 100 * current / lengthOfTask));
          current++;
        }
        publish(new Progress(Component.LOG, "\n"));
        return "Done";
      }
      private final Random r = new Random();
      private void convertFileToSomething() throws InterruptedException{
        boolean flag = false;
        int current = 0;
        int lengthOfTask = 10+r.nextInt(50);
        while(current&lt;=lengthOfTask &amp;&amp; !isCancelled()) {
          if(isPaused) {
            try{
              Thread.sleep(500);
            }catch(InterruptedException ie) {
              return;
            }
            publish(new Progress(Component.PAUSE, flag));
            flag = !flag;
            continue;
          }
          int iv = 100 * current / lengthOfTask;
          Thread.sleep(20); // dummy
          publish(new Progress(Component.FILE, iv+1));
          current++;
        }
      }
      @Override protected void process(java.util.List&lt;Progress&gt; chunks) {
        for(Progress s: chunks) {
          switch(s.component) {
            case TOTAL: bar1.setValue((Integer)s.value); break;
            case FILE:  bar2.setValue((Integer)s.value); break;
            case LOG:   area.append((String)s.value); break;
            case PAUSE: {
              if((Boolean)s.value) {
                area.append("*");
              }else{
                try{
                  Document doc = area.getDocument();
                  doc.remove(area.getDocument().getLength()-1, 1);
                }catch(Exception ex) {
                    ex.printStackTrace();
                }
              }
              break;
            }
          }
        }
      }
      @Override public void done() {
        //...
      }
    };
    worker.execute();
  }
}
private boolean isPaused = false;
class PauseAction extends AbstractAction{
  public PauseAction() {
    super("pause");
  }
  @Override public void actionPerformed(ActionEvent evt) {
    isPaused = (worker!=null &amp;&amp; !worker.isCancelled() &amp;&amp; !isPaused);
    JButton b = (JButton)evt.getSource();
    b.setText(isPaused?"resume":"pause");
  }
}
</code></pre>

### 解説
`SwingWorker#doInBackground()`内のループで一時停止のフラグを参照し、一時停止状態の場合は本来の処理(上記のサンプルではカウントアップするだけ)を行わずに、`Thread.sleep(...)`と停止中を表現するコンポーネントの更新(`JTextArea`の文字列を点滅)のみ繰り返すようになっています。

### 参考リンク
- [SwingWorkerを使った処理の中断と進捗状況表示](http://terai.xrea.jp/Swing/SwingWorker.html)
- [SwingWorkerで複数のJProgressBarを使用する](http://terai.xrea.jp/Swing/TwoProgressBars.html)

<!-- dummy comment line for breaking list -->

### コメント
