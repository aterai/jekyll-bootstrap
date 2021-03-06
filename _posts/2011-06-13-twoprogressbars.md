---
layout: post
category: swing
folder: TwoProgressBars
title: SwingWorkerで複数のJProgressBarを使用する
tags: [SwingWorker, JProgressBar, Enum, PropertyChangeListener]
author: aterai
pubdate: 2011-06-13T13:44:00+09:00
description: ひとつのSwingWorkerで、進捗を表示するJProgressBarをふたつ使用します。
image: https://lh6.googleusercontent.com/-S6ko35_DIi8/TfWPa08dHvI/AAAAAAAAA9I/MNhC-0LF8YQ/s800/TwoProgressBars.png
comments: true
---
## 概要
ひとつの`SwingWorker`で、進捗を表示する`JProgressBar`をふたつ使用します。

{% download https://lh6.googleusercontent.com/-S6ko35_DIi8/TfWPa08dHvI/AAAAAAAAA9I/MNhC-0LF8YQ/s800/TwoProgressBars.png %}

## サンプルコード
<pre class="prettyprint"><code>enum ComponentType { TOTAL, FILE, LOG }
class Progress {
  public final Object value;
  public final ComponentType componentType;
  public Progress(ComponentType componentType, Object value) {
    this.componentType = componentType;
    this.value = value;
  }
}
// ...
worker = new SwingWorker&lt;String, Progress&gt;() {
  private final Random r = new Random();
  @Override public String doInBackground() throws InterruptedException {
    int current = 0;
    int lengthOfTask = 12; // filelist.size();
    publish(new Progress(ComponentType.LOG, "Length Of Task: " + lengthOfTask));
    publish(new Progress(ComponentType.LOG, "\n------------------------------\n"));
    while (current &lt; lengthOfTask &amp;&amp; !isCancelled()) {
      if (!bar1.isDisplayable()) {
        return "Disposed";
      }
      convertFileToSomething();
      publish(new Progress(ComponentType.LOG, "*"));
      publish(new Progress(ComponentType.TOTAL, 100 * current / lengthOfTask));
      current++;
    }
    publish(new Progress(ComponentType.LOG, "\n"));
    return "Done";
  }

  private void convertFileToSomething() throws InterruptedException {
    int current = 0;
    int lengthOfTask = 10 + r.nextInt(50); // long lengthOfTask = file.length();
    while (current &lt;= lengthOfTask &amp;&amp; !isCancelled()) {
      int iv = 100 * current / lengthOfTask;
      Thread.sleep(20); // dummy
      publish(new Progress(Component.FILE, iv + 1));
      current++;
    }
  }

  @Override protected void process(List&lt;Progress&gt; chunks) {
    for (Progress s: chunks) {
      switch (s.componentType) {
        case TOTAL: bar1.setValue((Integer) s.value); break;
        case FILE: bar2.setValue((Integer) s.value); break;
        case LOG: area.append((String) s.value); break;
      }
    }
  }
  // ...
</code></pre>

## 解説
上記のサンプルでは、デフォルトで用意されている`SwingWorker#setProgress(int)`は使用せず、以下の`3`つのコンポーネントの状態を表す`Progress`クラスを作成し、これを`SwingWorker<String, Progress>#publish(Progress)`メソッドに与えて`EDT`上でそれぞれの状態を更新しています。

- 全体の進捗を表示する`JProgressBar`
- 個々のファイル処理(このサンプルでは`Thread.sleep(...)`するだけのダミー)の進捗を表示する`JProgressBar`
- ログを表示する`JTextArea`

<!-- dummy comment line for breaking list -->

- - - -
`SwingWorker`に別の`PropertyChangeListener`を追加する方法もあります。

<pre class="prettyprint"><code>worker.firePropertyChange("file-progress", iv, iv + 1);
// ...
class SubProgressListener implements PropertyChangeListener {
  private final JProgressBar progressBar;
  public SubProgressListener(JProgressBar progressBar) {
    this.progressBar = progressBar;
    this.progressBar.setValue(0);
  }
  @Override public void propertyChange(PropertyChangeEvent e) {
    String strPropertyName = e.getPropertyName();
    if ("file-progress".equals(strPropertyName)) {
      int progress = (Integer) e.getNewValue();
      progressBar.setValue(progress);
    }
  }
}
</code></pre>

## 参考リンク
- [SwingWorkerを使った処理の中断と進捗状況表示](https://ateraimemo.com/Swing/SwingWorker.html)
- [SwingWorkerの一時停止と再開](https://ateraimemo.com/Swing/PauseResumeSwingWorker.html)

<!-- dummy comment line for breaking list -->

## コメント
