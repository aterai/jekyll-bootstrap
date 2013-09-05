---
layout: post
title: JFrameの終了をキャンセル
category: swing
folder: WindowClosing
tags: [JFrame, WindowListener]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-08-09

## JFrameの終了をキャンセル
`JFrame`を閉じる前に、本当に終了してよいか、終了をキャンセルするかなどを確認するダイアログを表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTWuSq18TI/AAAAAAAAAps/aCkiOWRqfDE/s800/WindowClosing.png)

### サンプルコード
<pre class="prettyprint"><code>public static final String ASTERISK_TITLEBAR = "unsaved";
private final JTextArea textarea = new JTextArea();
private final JButton saveButton = new JButton("save");
private final JFrame frame;
private final String title;
public MainPanel(final JFrame frame) {
  super(new BorderLayout());
  this.frame = frame;
  this.title = frame.getTitle();
  frame.setDefaultCloseOperation(WindowConstants.DO_NOTHING_ON_CLOSE);
  addPropertyChangeListener(new PropertyChangeListener() {
    @Override public void propertyChange(PropertyChangeEvent e) {
      if(ASTERISK_TITLEBAR.equals(e.getPropertyName())) {
        Boolean unsaved = (Boolean)e.getNewValue();
        frame.setTitle((unsaved?"* ":"")+title);
      }
    }
  });
  frame.addWindowListener(new WindowAdapter() {
    @Override public void windowClosing(WindowEvent e) {
      System.out.println("windowClosing");
      maybeExit();
    }
    @Override public void windowClosed(WindowEvent e) {
      System.out.println("windowClosed");
      System.exit(0); // webstart
    }
  });
  textarea.setText("Test Test Test");
  textarea.getDocument().addDocumentListener(new DocumentListener() {
    @Override public void insertUpdate(DocumentEvent e) {
      fireUnsavedFlagChangeEvent(true);
    }
    @Override public void removeUpdate(DocumentEvent e) {
      fireUnsavedFlagChangeEvent(true);
    }
    @Override public void changedUpdate(DocumentEvent e) {}
  });
  saveButton.setEnabled(false);
  saveButton.addActionListener(new ActionListener() {
    @Override public void actionPerformed(ActionEvent ae) {
      System.out.println("Save(dummy)");
      fireUnsavedFlagChangeEvent(false);
    }
  });
  add(new JScrollPane(textarea));
  Box box = Box.createHorizontalBox();
  box.add(Box.createHorizontalGlue());
  box.add(new JButton(new AbstractAction("exit") {
    @Override public void actionPerformed(ActionEvent e) {
      System.out.println("exit button");
      maybeExit();
    }
  }));
  box.add(Box.createHorizontalStrut(5));
  box.add(saveButton);
  add(box, BorderLayout.SOUTH);
  setPreferredSize(new Dimension(320, 240));
}

private void maybeExit() {
  if(title.equals(frame.getTitle())) {
    System.out.println("The document has already been saved,"+
                       " exit without doing anything.");
    frame.dispose();
    return;
  }
  java.awt.Toolkit.getDefaultToolkit().beep();
  Object[] options = { "Save", "Discard", "Cancel" };
  int retValue = JOptionPane.showOptionDialog(frame,
        "&lt;html&gt;Save: Exit &amp; Save Changes&lt;br&gt;"+
           "Discard: Exit &amp; Discard Changes&lt;br&gt;"+
            "Cancel: Continue&lt;/html&gt;",
        "Exit Options",
        JOptionPane.YES_NO_CANCEL_OPTION,
        JOptionPane.WARNING_MESSAGE, null, options, options[0]);
  if(retValue==JOptionPane.YES_OPTION) {
    System.out.println("exit");
    //boolean ret = dummyDocumentSaveMethod();
    //if(ret) { //saved and exit
    //  frame.dispose();
    //}else{ //error and cancel exit
    //  return;
    //}
    frame.dispose();
  }else if(retValue==JOptionPane.NO_OPTION) {
    System.out.println("Exit without save");
    frame.dispose();
  }else if(retValue==JOptionPane.CANCEL_OPTION) {
    System.out.println("Cancel exit");
  }
}
private void fireUnsavedFlagChangeEvent(boolean unsaved) {
  if(unsaved) {
    saveButton.setEnabled(true);
    firePropertyChange(ASTERISK_TITLEBAR, Boolean.FALSE, Boolean.TRUE);
  }else{
    saveButton.setEnabled(false);
    firePropertyChange(ASTERISK_TITLEBAR, Boolean.TRUE, Boolean.FALSE);
  }
}
</code></pre>

### 解説
上記のサンプルでは、アプリケーションの終了時に、ドキュメントが保存されているかどうかで処理を変更するために、ウィンドウイベントを受け取るためのリスナーを設定しています。

- `WindowAdapter#windowClosing(WindowEvent e)`
    - システムメニューでウィンドウを閉じようとしたときに呼び出されるリスナーのメソッド
        - `OS`が`Windows`なら、<kbd>Alt</kbd>+<kbd>F4</kbd>キーを押す
        - タイトルバー左上にあるアイコンをクリックし、ポップアップメニューで閉じるを選択
        - タイトルバー右上の×ボタンをクリック
        - `JButton`や`JMenu`などをクリックした時に、対象となる`frame`の`windowClosing`を呼び出したい場合は、`frame.dispatchEvent(new WindowEvent(frame, WindowEvent.WINDOW_CLOSING));`
    - `frame.dispose();`では、このメソッドは呼び出されない
- `WindowAdapter#windowClosed(WindowEvent e)`
    - `frame.dispose()`で、ウィンドウがクローズされたときに呼び出されるリスナーのメソッド
    - `windowClosing`の後、自動的に`windowClosed`が呼び出されるのは、`WindowConstants.DISPOSE_ON_CLOSE`の場合のみ
    - このサンプルでは、`Web Start`から起動しても終了できるように、`frame.dispose()`すれば必ず呼び出されるこのメソッド中で`System.exit(0);`を使い、`JVM`ごとシャットダウンしている
        - `Web Start`でシャットダウンする必要性については、[When DISPOSE_ON_CLOSE met WebStart](http://www.pushing-pixels.org/?p=232)を参考に

<!-- dummy comment line for breaking list -->

- - - -
`JFrame#setDefaultCloseOperation`メソッドで、タイトルバー右上の×ボタンをクリック(=デフォルトの終了処理)し、`windowClosing`が呼ばれた後(このため`windowClosing`中で変更しても有効)の動作を設定できます(これらの動作については、`JFrame#processWindowEvent(WindowEvent)`のソースを参照)。

- `WindowConstants.DO_NOTHING_ON_CLOSE`
    - `windowClosing`が呼ばれた後になにもしない(終了しない)
    - `return;`と同じ
    - このサンプルでは、`WindowConstants.DO_NOTHING_ON_CLOSE`を設定しているが、システムメニューでウィンドウを閉じても、下の`exit`ボタンと同じ処理になるように、`windowClosing`の中で終了処理を行うメソッド(`maybeExit()`)を呼び出し、そこでドキュメントの保存状態によって`frame.dispose();`を呼んでいる
- `WindowConstants.HIDE_ON_CLOSE`
    - `windowClosing`が呼ばれた後でウインドウは非表示になる
    - `setVisible(false);`と同じ
    - 初期値
- `WindowConstants.DISPOSE_ON_CLOSE`
    - `windowClosing`が呼ばれた後でウインドウは破棄される
    - `dispose();`と同じ
    - `dispose()`されるので、この後`windowClosed`が呼び出される
- `WindowConstants.EXIT_ON_CLOSE`
    - `windowClosing`が呼ばれた後で`JVM`がシャットダウンれさる
    - `System.exit(0);`と同じ
    - `dispose()`されないので、`windowClosed`は呼び出されない

<!-- dummy comment line for breaking list -->

- - - -
テキストが変更された場合、タイトル文字列の先頭にアスタリスクを付けることで、保存状態の可視化と保持を行っています。

- ドキュメントに文字列が追加されたとき、ソース側から`firePropertyChange`などで、リスナーに変更をイベントで報告
- リスナー側ではこのイベントを受け、`JFrame`のタイトルを変更

<!-- dummy comment line for breaking list -->

### 参考リンク
- [WindowListener (Java Platform SE 6)](http://docs.oracle.com/javase/jp/6/api/java/awt/event/WindowListener.html)
- [When DISPOSE_ON_CLOSE met WebStart](http://www.pushing-pixels.org/?p=232)

<!-- dummy comment line for breaking list -->

### コメント
- 私は以前　この終了をキャンセルするかどうかなどを確認するダイアログを作成したことがあります。あなたのソースコードは　参考のかいがあると思います。でも　ひとつの問題があるんですけど、`textarea`に入力した文字列を削除する場合は　`JFrame`のタイトルが変化されていません、どうですか？ -- [そうがい](http://terai.xrea.jp/そうがい.html) 2007-10-08 (Mon) 15:11:56
    - こんばんは。「`123`->`12345`(`45`追加)->`123`(`45`削除)」と追加、削除をして元の状態に戻っても、タイトルが変化しないのは、仕様です。比較のコストが大きくなってしまいそうで嫌なので避けています。 -- [aterai](http://terai.xrea.jp/aterai.html) 2007-10-08 (月) 23:07:09
- 変更をアスタリスクに変更、コードの構成を変更、スクリーンショット更新 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-04-22 (火) 21:35:25
- メモ: [シャットダウンフック API の設計](http://docs.oracle.com/javase/jp/6/technotes/guides/lang/hook-design.html) -- [aterai](http://terai.xrea.jp/aterai.html) 2008-11-25 (火) 11:25:18

<!-- dummy comment line for breaking list -->
