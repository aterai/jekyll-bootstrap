---
layout: post
title: JTableのセルにJProgressBarを表示
category: swing
folder: TableCellProgressBar
tags: [JTable, JProgressBar, TableCellRenderer, SwingWorker]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-10-01

## JTableのセルにJProgressBarを表示
`JTable`のセルに`JProgressBar`を使用して進捗を表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.ggpht.com/_9Z4BYR88imo/TQTUYeEtfWI/AAAAAAAAAl8/47mUyOKeiQY/s800/TableCellProgressBar.png)

### サンプルコード
<pre class="prettyprint"><code>class ProgressRenderer extends DefaultTableCellRenderer {
  private final JProgressBar b = new JProgressBar(0, 100);
  public ProgressRenderer() {
    super();
    setOpaque(true);
    b.setBorder(BorderFactory.createEmptyBorder(1,1,1,1));
  }
  @Override public Component getTableCellRendererComponent(JTable table, Object value,
                                               boolean isSelected, boolean hasFocus,
                                               int row, int column) {
    Integer i = (Integer)value;
    String text = "Done";
    if(i&lt;0) {
      text = "Canceled";
    }else if(i&lt;100) {
      b.setValue(i);
      return b;
    }
    super.getTableCellRendererComponent(table, text, isSelected, hasFocus, row, column);
    return this;
  }
}
</code></pre>
<pre class="prettyprint"><code>private final Executor executor = Executors.newCachedThreadPool();
//...
final int rowNumber = model.getRowCount();
SwingWorker&lt;Integer, Integer&gt; worker = new SwingWorker&lt;Integer, Integer&gt;() {
  private int sleepDummy = new Random().nextInt(100) + 1;
  private int lengthOfTask = 120;
  @Override protected Integer doInBackground() {
    int current = 0;
    while(current&lt;lengthOfTask &amp;&amp; !isCancelled()) {
      current++;
      try {
        Thread.sleep(sleepDummy);
      }catch(InterruptedException ie) {
        publish(-1);
        break;
      }
      publish(100 * current / lengthOfTask);
    }
    return sleepDummy*lengthOfTask;
  }
  @Override protected void process(java.util.List&lt;Integer&gt; chunks) {
    for(Integer value : chunks) {
      model.setValueAt(value, rowNumber, 2);
    }
    //model.fireTableCellUpdated(rowNumber, 2);
  }
  @Override protected void done() {
    String text = null;
    int i = -1;
    if(isCancelled()) {
      text = "Canceled";
    }else{
      try{
        i = get();
        text = "Done";
      }catch(Exception ignore) {
        ignore.printStackTrace();
        text = ignore.getMessage();
      }
    }
    System.out.println(rowNumber +":"+text+"("+i+"ms)");
  }
};
model.addTest(new Test("example", 0), worker);
executor.execute(worker); //1.6.0_18
//worker.execute(); //1.6.0_21
</code></pre>

### 解説
上記のサンプルでは、`add`ボタンをクリックすると、`JDK 6`の`SwingWorker`を使用したダミータスクが起動して、進捗状況が`Cell`内の`JProgressBar`で表示されます。

`ProgressRenderer`は、`JProgressBar`を一つ持ち、ダミータスクが動いている間は、その`JProgressBar`に値を設定して描画用のコンポーネントとして返し、タスクが終了(またはキャンセル)されたら`JLabel`(自分自身、`DefaultTableCellRenderer`)に文字列を設定して返すようになっています。

- - - -
このサンプルでは、行番号をキーにしているため、例えばモデルから行を削除するときに実行中のタスクが手前の行などにあった場合はエラーが発生してしまいます。このため、実際には削除は行わず、フィルタを使って非表示にしています(参考: [RowFilterでJTableの行をフィルタリング](http://terai.xrea.jp/Swing/RowFilter.html))。

- - - -
- メモ
    - [Swing - Maximum number of SwingWorker objects in a Swing app?](https://forums.oracle.com/thread/1364600)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>public abstract class SwingWorker&lt;T, V&gt; implements RunnableFuture&lt;T&gt; {
  /**
   * number of worker threads.
   */
  private static final int MAX_WORKER_THREADS = 10;
</code></pre>

### 参考リンク
- [SwingWorkerを使った処理の中断と進捗状況表示](http://terai.xrea.jp/Swing/SwingWorker.html)

<!-- dummy comment line for breaking list -->

### コメント
- ~~`Windows` + `Java 1.7.0-ea-b24`での動作がおかしいみたいです。 -- [aterai](http://terai.xrea.jp/aterai.html) 2007-12-19 (水) 21:08:43~~
- メモ: [Bug 87 - Icedtea 1.7.0 and SwingWorker problem](http://icedtea.classpath.org/bugzilla/show_bug.cgi?id=87) -- [aterai](http://terai.xrea.jp/aterai.html) 2008-01-31 (木) 15:56:51
- `JDK 1.6.0_18`での修正: [Bug ID: 6799345 JFC demos threw exception in the Java Console when applets are closed](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6799345) -- [aterai](http://terai.xrea.jp/aterai.html) 2010-01-20 (水) 17:34:04
    - 代わりに、`Executors.newCachedThreadPool().execute(worker);`のようにしているけど、これでいいのだろうか？ 実行中にアプリケーションを終了する場合は、`ExecutorService#shutdown()`などを呼んだほうがよさそうだけど、このサンプルでは、`WindowConstants.EXIT_ON_CLOSE`で`VM`ごと落としているので、関係ない？ -- [aterai](http://terai.xrea.jp/aterai.html) 2010-01-20 (水) 17:43:10
    - 正常に動かなくなっている[Improve Application Performance With SwingWorker in Java SE 6](http://java.sun.com/developer/technicalArticles/javase/swingworker/)のサンプルがどう修正されるか、様子見。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-01-20 (水) 17:47:11
- メモ: [Bug ID: 6826514 SwingWorker: done() called before doInBackground() returns, when cancelled](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6826514) -- [aterai](http://terai.xrea.jp/aterai.html) 2010-02-04 (木) 16:54:27
- メモ: [Bug ID: 6880336 SwingWorker deadlocks due one thread in the swingworker-pool](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6880336) -- [aterai](http://terai.xrea.jp/aterai.html) 2010-03-15 (月) 18:01:12
    - 修正されたようです。[Java SE 6 Update 21 Bug Fixes](http://java.sun.com/javase/6/webnotes/BugFixes6u21.html) -- [aterai](http://terai.xrea.jp/aterai.html) 2010-07-08 (木) 21:48:24

<!-- dummy comment line for breaking list -->
