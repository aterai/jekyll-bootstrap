---
layout: post
category: swing
folder: TableCellProgressBar
title: JTableのセルにJProgressBarを表示
tags: [JTable, JProgressBar, TableCellRenderer, SwingWorker]
author: aterai
pubdate: 2007-10-01T16:23:32+09:00
description: JTableのセルにJProgressBarを使用して進捗を表示します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTUYeEtfWI/AAAAAAAAAl8/47mUyOKeiQY/s800/TableCellProgressBar.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2008/03/jprogressbar-in-jtable-cell.html
    lang: en
comments: true
---
## 概要
`JTable`のセルに`JProgressBar`を使用して進捗を表示します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTUYeEtfWI/AAAAAAAAAl8/47mUyOKeiQY/s800/TableCellProgressBar.png %}

## サンプルコード
<pre class="prettyprint"><code>class ProgressRenderer extends DefaultTableCellRenderer {
  private final JProgressBar b = new JProgressBar(0, 100);
  public ProgressRenderer() {
    super();
    setOpaque(true);
    b.setBorder(BorderFactory.createEmptyBorder(1, 1, 1, 1));
  }
  @Override public Component getTableCellRendererComponent(JTable table, Object value,
      boolean isSelected, boolean hasFocus, int row, int column) {
    Integer i = (Integer) value;
    String text = "Done";
    if (i &lt; 0) {
      text = "Canceled";
    } else if (i &lt; 100) {
      b.setValue(i);
      return b;
    }
    super.getTableCellRendererComponent(table, text, isSelected, hasFocus, row, column);
    return this;
  }
}
</code></pre>
<pre class="prettyprint"><code>private final Executor executor = Executors.newCachedThreadPool();
// ...
final int rowNumber = model.getRowCount();
SwingWorker&lt;Integer, Integer&gt; worker = new SwingWorker&lt;Integer, Integer&gt;() {
  private int sleepDummy = new Random().nextInt(100) + 1;
  private int lengthOfTask = 120;
  @Override protected Integer doInBackground() {
    int current = 0;
    while (current &lt; lengthOfTask &amp;&amp; !isCancelled()) {
      current++;
      try {
        Thread.sleep(sleepDummy);
      } catch (InterruptedException ie) {
        publish(-1);
        break;
      }
      publish(100 * current / lengthOfTask);
    }
    return sleepDummy * lengthOfTask;
  }
  @Override protected void process(List&lt;Integer&gt; chunks) {
    for (Integer value: chunks) {
      model.setValueAt(value, rowNumber, 2);
    }
    //model.fireTableCellUpdated(rowNumber, 2);
  }
  @Override protected void done() {
    String text = null;
    int i = -1;
    if (isCancelled()) {
      text = "Canceled";
    } else {
      try {
        i = get();
        text = "Done";
      } catch (Exception ignore) {
        ignore.printStackTrace();
        text = ignore.getMessage();
      }
    }
    System.out.println(rowNumber + ":" + text + "(" + i + "ms)");
  }
};
model.addTest(new Test("example", 0), worker);
executor.execute(worker); //1.6.0_18
//worker.execute(); //1.6.0_21
</code></pre>

## 解説
上記のサンプルでは、`add`ボタンをクリックすると、`SwingWorker`を使用したダミータスクが起動し、その進捗状況が`2`列目セル内の`JProgressBar`で表示されます。

`ProgressRenderer`は`JProgressBar`を一つ持ち、ダミータスクが動いている間は、その`JProgressBar`に値を設定して描画用のコンポーネントとして返し、タスクが終了(またはキャンセル)されたら`JLabel`(自分自身、`DefaultTableCellRenderer`)に文字列を設定して返しています。

- - - -
- このサンプルでは、行番号をキーにしているため、例えばモデルから行を削除するときに実行中のタスクが手前の行などに存在する場合はエラーが発生する
    - これを回避するため、実際には行の削除を実行せず、フィルタを使って行を非表示に設定する
    - 参考: [RowFilterでJTableの行をフィルタリング](https://ateraimemo.com/Swing/RowFilter.html)

<!-- dummy comment line for breaking list -->

- - - -
- メモ
    - [Swing - Maximum number of SwingWorker objects in a Swing app?](https://community.oracle.com/thread/1364600)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>public abstract class SwingWorker&lt;T, V&gt; implements RunnableFuture&lt;T&gt; {
  /**
   * number of worker threads.
   */
  private static final int MAX_WORKER_THREADS = 10;
</code></pre>

## 参考リンク
- [SwingWorkerを使った処理の中断と進捗状況表示](https://ateraimemo.com/Swing/SwingWorker.html)
- [TableCellRendererに進捗文字列を設定したJProgressBarを使用する](https://ateraimemo.com/Swing/StringPaintedCellProgressBar.html)
- [SwingWorkerを一スレッドづつ順番に実行する](https://ateraimemo.com/Swing/SingleThreadExecutor.html)

<!-- dummy comment line for breaking list -->

## コメント
- ~~`Windows` + `Java 1.7.0-ea-b24`での動作がおかしいみたいです。 -- *aterai* 2007-12-19 (水) 21:08:43~~
- メモ: [Bug 87 - Icedtea 1.7.0 and SwingWorker problem](http://icedtea.classpath.org/bugzilla/show_bug.cgi?id=87) -- *aterai* 2008-01-31 (木) 15:56:51
- `JDK 1.6.0_18`での修正: [&#91;JDK-6799345&#93; JFC demos threw exception in the Java Console when applets are closed - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-6799345) -- *aterai* 2010-01-20 (水) 17:34:04
    - 代わりに、`Executors.newCachedThreadPool().execute(worker);`のようにしているけど、これでいいのだろうか？ 実行中にアプリケーションを終了する場合は、`ExecutorService#shutdown()`などを呼んだほうがよさそうだけど、このサンプルでは、`WindowConstants.EXIT_ON_CLOSE`で`VM`ごと落としているので、関係ない？ -- *aterai* 2010-01-20 (水) 17:43:10
    - 正常に動かなくなっている[Improve Application Performance With SwingWorker in Java SE 6](https://www.oracle.com/technetwork/articles/javase/swingworker-137249.html)などのサンプルがどう修正されるか、様子見。 -- *aterai* 2010-01-20 (水) 17:47:11
    - メモ: [&#91;JDK-6880336&#93; SwingWorker deadlocks due one thread in the swingworker-pool - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-6880336) -- *aterai* 2010-03-15 (月) 18:01:12
    - 修正されたようです。[Java SE 6 Update 21 Bug Fixes](http://www.oracle.com/technetwork/java/javase/bugfixes6u21-156339.html) -- *aterai* 2010-07-08 (木) 21:48:24
- メモ: [&#91;JDK-6826514&#93; SwingWorker: done() called before doInBackground() returns, when cancelled - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-6826514) -- *aterai* 2010-02-04 (木) 16:54:27

<!-- dummy comment line for breaking list -->
