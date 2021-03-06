---
layout: post
category: swing
folder: WindowClosing
title: JFrameの終了をキャンセル
tags: [JFrame, WindowListener, JOptionPane]
author: aterai
pubdate: 2004-08-09T01:11:16+09:00
description: JFrameを閉じる前に、本当に終了してよいか、終了をキャンセルするかなどを確認するダイアログを表示します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTWuSq18TI/AAAAAAAAAps/aCkiOWRqfDE/s800/WindowClosing.png
comments: true
---
## 概要
`JFrame`を閉じる前に、本当に終了してよいか、終了をキャンセルするかなどを確認するダイアログを表示します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTWuSq18TI/AAAAAAAAAps/aCkiOWRqfDE/s800/WindowClosing.png %}

## サンプルコード
<pre class="prettyprint"><code>class SaveHandler extends WindowAdapter implements DocumentListener, ActionListener {
  //public static final String ASTERISK_TITLEBAR = "unsaved";
  public static final String CMD_SAVE = "save";
  public static final String CMD_EXIT = "exit";
  private final JFrame frame;
  private final String title;
  private final List&lt;JComponent&gt; list = new ArrayList&lt;&gt;();

  public SaveHandler(JFrame frame) {
    super();
    this.frame = frame;
    this.title = frame.getTitle();
  }

  //WindowAdapter
  @Override public void windowClosing(WindowEvent e) {
    System.out.println("windowClosing");
    maybeExit();
  }

  @Override public void windowClosed(WindowEvent e) {
    System.out.println("windowClosed");
    System.exit(0); //webstart
  }

  //ActionListener
  @Override public void actionPerformed(ActionEvent e) {
    String cmd = e.getActionCommand();
    if (CMD_EXIT.equals(cmd)) {
      maybeExit();
    } else if (CMD_SAVE.equals(cmd)) {
      fireUnsavedFlagChangeEvent(false);
    }
  }

  //DocumentListener
  @Override public void insertUpdate(DocumentEvent e) {
    fireUnsavedFlagChangeEvent(true);
  }

  @Override public void removeUpdate(DocumentEvent e) {
    fireUnsavedFlagChangeEvent(true);
  }

  @Override public void changedUpdate(DocumentEvent e) {
    /* not needed */
  }

  private void maybeExit() {
    if (title.equals(frame.getTitle())) {
      System.out.println(
          "The document has already been saved, exit without doing anything.");
      frame.dispose();
      return;
    }
    Toolkit.getDefaultToolkit().beep();
    Object[] options = {"Save", "Discard", "Cancel"};
    int retValue = JOptionPane.showOptionDialog(
        frame, "&lt;html&gt;Save: Exit &amp; Save Changes&lt;br&gt;"
        + "Discard: Exit &amp; Discard Changes&lt;br&gt;Cancel: Continue&lt;/html&gt;",
        "Exit Options", JOptionPane.YES_NO_CANCEL_OPTION,
        JOptionPane.INFORMATION_MESSAGE, null, options, options[0]);
    if (retValue == JOptionPane.YES_OPTION) {
      System.out.println("exit");
      //boolean ret = dummyDocumentSaveMethod();
      // if (ret) { // saved and exit
      //   frame.dispose();
      // } else { // error and cancel exit
      //   return;
      // }
      frame.dispose();
    } else if (retValue == JOptionPane.NO_OPTION) {
      System.out.println("Exit without save");
      frame.dispose();
    } else if (retValue == JOptionPane.CANCEL_OPTION) {
      System.out.println("Cancel exit");
    }
  }

  public void addEnabledFlagComponent(JComponent c) {
    list.add(c);
  }

  public void removeEnabledFlagComponent(JComponent c) {
    list.remove(c);
  }

  private void fireUnsavedFlagChangeEvent(boolean unsaved) {
    frame.setTitle(String.format("%s%s", unsaved ? "* " : "", title));
    for (JComponent c : list) {
      c.setEnabled(unsaved);
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、アプリケーションの終了時に、ドキュメントが保存されているかどうかで処理を変更するために、ウィンドウイベントを受け取るためのリスナーを設定しています。

- `WindowListener#windowClosing(WindowEvent e)`
    - システムメニューでウィンドウを閉じようとしたときに呼び出されるリスナーのメソッド
        - `OS`が`Windows`なら、<kbd>Alt+F4</kbd>キーを押す
        - タイトルバー左上にあるアイコンをクリックし、ポップアップメニューで閉じるを選択
        - タイトルバー右上の`×`ボタンをクリック
        - `JButton`や`JMenu`などをクリックした時に、対象となる`frame`の`windowClosing`を呼び出したい場合は、`frame.dispatchEvent(new WindowEvent(frame, WindowEvent.WINDOW_CLOSING));`
    - `frame.dispose();`では、このメソッドは呼び出されない
- `WindowListener#windowClosed(WindowEvent e)`
    - `frame.dispose()`で、ウィンドウがクローズされたときに呼び出されるリスナーのメソッド
    - `windowClosing`の後、自動的に`windowClosed`が呼び出されるのは、`WindowConstants.DISPOSE_ON_CLOSE`の場合のみ
    - このサンプルでは`Web Start`から起動しても終了できるように、`frame.dispose()`すれば必ず呼び出されるこのメソッド中で`System.exit(0);`を使い、`JVM`ごとシャットダウンしている
        - 参考: [When DISPOSE_ON_CLOSE met WebStart · Pushing Pixels](https://www.pushing-pixels.org/2008/01/14/when-dispose_on_close-met-webstart.html)

<!-- dummy comment line for breaking list -->

- - - -
`JFrame#setDefaultCloseOperation`メソッドで、タイトルバー右上の×ボタンをクリック(デフォルトの終了処理)し、`windowClosing`が呼ばれた後(このため`windowClosing`中で変更しても有効)の動作を設定できます(これらの動作については、`JFrame#processWindowEvent(WindowEvent)`のソースを参照)。

- `WindowConstants.DO_NOTHING_ON_CLOSE`
    - `windowClosing`が呼ばれた後になにもしない(終了しない)
    - `return;`と同じ
    - このサンプルでは、`WindowConstants.DO_NOTHING_ON_CLOSE`を設定しているが、システムメニューでウィンドウを閉じても、下の`exit`ボタンと同じ処理になるように、`windowClosing`の中で終了処理を行うメソッド(`maybeExit()`)を呼び出し、そこでドキュメントの保存状態によって`frame.dispose();`を呼んでいる
- `WindowConstants.HIDE_ON_CLOSE`
    - `windowClosing`が呼ばれた後でウィンドウは非表示になる
    - `setVisible(false);`と同じ
    - 初期値
- `WindowConstants.DISPOSE_ON_CLOSE`
    - `windowClosing`が呼ばれた後でウィンドウは破棄される
    - `dispose();`と同じ
    - `dispose()`されるので、この後`windowClosed`が呼び出される
- `WindowConstants.EXIT_ON_CLOSE`
    - `windowClosing`が呼ばれた後で`JVM`がシャットダウンされる
    - `System.exit(0);`と同じ
    - `dispose()`されないので、`windowClosed`は呼び出されない

<!-- dummy comment line for breaking list -->

- - - -
テキストが変更された場合、タイトル文字列の先頭にアスタリスクを付けることで、保存状態の可視化と保持を行っています。

- ドキュメントに文字列が追加されたとき、ソース側から`firePropertyChange`などで、リスナーに変更をイベントで報告
- リスナー側ではこのイベントを受け、`JFrame`のタイトルを変更

<!-- dummy comment line for breaking list -->

## 参考リンク
- [WindowListener (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/event/WindowListener.html)
- [When DISPOSE_ON_CLOSE met WebStart](http://www.pushing-pixels.org/?p=232)

<!-- dummy comment line for breaking list -->

## コメント
- 私は以前　この終了をキャンセルするかどうかなどを確認するダイアログを作成したことがあります。あなたのソースコードは　参考のかいがあると思います。でも　ひとつの問題があるんですけど、`textarea`に入力した文字列を削除する場合は　`JFrame`のタイトルが変化されていません、どうですか？ -- *そうがい* 2007-10-08 (Mon) 15:11:56
    - こんばんは。「`123`→`12345`(`45`追加)→`123`(`45`削除)」と追加、削除をして元の状態に戻っても、タイトルが変化しないのは、仕様です。比較のコストが大きくなってしまいそうで嫌なので避けています。 -- *aterai* 2007-10-08 (月) 23:07:09
- 変更をアスタリスクに変更、コードの構成を変更、スクリーンショット更新 -- *aterai* 2008-04-22 (火) 21:35:25
- メモ: [シャットダウン・フックAPIの設計](https://docs.oracle.com/javase/jp/8/docs/technotes/guides/lang/hook-design.html) -- *aterai* 2008-11-25 (火) 11:25:18

<!-- dummy comment line for breaking list -->
