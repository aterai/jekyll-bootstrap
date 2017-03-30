---
layout: post
category: swing
folder: BasicComboPopup
title: JComboBoxを使ってポップアップメニューをスクロール
tags: [BasicComboPopup, JTextPane, JComboBox]
author: aterai
pubdate: 2005-10-17T19:42:35+09:00
description: JComboBoxを使ってスクロール可能なポップアップメニューを表示します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTH_tpIbsI/AAAAAAAAASE/DrHgihVbnn0/s800/BasicComboPopup.png
comments: true
---
## 概要
`JComboBox`を使ってスクロール可能なポップアップメニューを表示します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTH_tpIbsI/AAAAAAAAASE/DrHgihVbnn0/s800/BasicComboPopup.png %}

## サンプルコード
<pre class="prettyprint"><code>class EditorComboPopup extends BasicComboPopup {
  private final JTextComponent textArea;
  private transient MouseAdapter listener;
  protected EditorComboPopup(JTextComponent textArea, JComboBox cb) {
    super(cb);
    this.textArea = textArea;
  }
  @Override protected void installListListeners() {
    super.installListListeners();
    listener = new MouseAdapter() {
      @Override public void mouseClicked(MouseEvent e) {
        hide();
        String str = (String) comboBox.getSelectedItem();
        try {
          Document doc = textArea.getDocument();
          doc.insertString(textArea.getCaretPosition(), str, null);
        } catch (BadLocationException ex) {
          ex.printStackTrace();
        }
      }
    };
    if (Objects.nonNull(list)) {
      list.addMouseListener(listener);
    }
  }
  @Override public void uninstallingUI() {
    if (Objects.nonNull(listener)) {
      list.removeMouseListener(listener);
      listener = null;
    }
    super.uninstallingUI();
  }
  @Override public boolean isFocusable() {
    return true;
  }
}
</code></pre>

## 解説
上記のサンプルでは、<kbd>Shift+Tab</kbd>でポップアップメニューが表示され、<kbd>Up</kbd>, <kbd>Down</kbd>キーで移動、<kbd>Enter</kbd>で`JTextPane`のカーソルの後に選択された文字列が入力されます。

`JComboBox`のポップアップ部分の`UI`を表現する`BasicComboPopup`を利用することで、スクロールバーをもつポップアップメニューを実現しています。

フォーカスを取得して、キー入力で選択を変更できるように、`BasicComboPopup#isFocusable`メソッドをオーバーライドしています。また、`BasicComboPopup#show`したあと、`BasicComboPopup#requestFocusInWindow`する必要があります。

- - - -
- ~~`JFrame`から、ポップアップメニューがはみ出す(親`Window`が`HeavyWeightWindow`になる)場合、カーソルキーなどで、アイテムが移動選択できないバグがある~~
    - `SwingUtilities.getWindowAncestor(popup).toFront();`を追加して修正(`Ubuntu`ではうまく動作しない？)
        
        <pre class="prettyprint"><code>private void popupMenu(ActionEvent e) {
          Rectangle rect = getMyPopupRect();
          popup.show(jtp, rect.x, rect.y + rect.height);
          EventQueue.invokeLater(new Runnable() {
            @Override public void run() {
              SwingUtilities.getWindowAncestor(popup).toFront();
              popup.requestFocusInWindow();
            }
          });
        }
</code></pre>
    
    		#ref(https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTICNIyr1I/AAAAAAAAASI/CorNUGA0pF8/s800/BasicComboPopup1.png)
- ~~ただし、バージョン(`6uN`？)、`Web Start`などで実行すると、`AccessControlException`が発生する~~
    - `Exception in thread "AWT-EventQueue-0" java.security.AccessControlException: access denied (java.awt.AWTPermission setWindowAlwaysOnTop)`
- 上記の`AccessControlException`は、`6u10 build b26`で修正されている
    - [Bug ID: 6675802 Regression: heavyweight popups cause SecurityExceptions in applets](http://bugs.java.com/bugdatabase/view_bug.do?bug_id=6675802)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Swing - Scrollable PopupMenu](https://community.oracle.com/thread/1367473)

<!-- dummy comment line for breaking list -->

## コメント
- 大変参考になりました。その上、マウスクリックで文字列を選定できるようにしたいですが、どうすればいかがですか？ -- *java* 2008-01-08 (火) 16:25:30
    - どうもです。とりあえず(勘違いしているかもしれませんが、以前はマウスクリックでも動作していたような…？)、手抜きですが、`BasicComboPopup#installListListeners`メソッドをオーバーライドしてマウスリスナーを追加してみました。 -- *aterai* 2008-01-08 (火) 18:23:22
- 助かりました！感動です！ご回答ありがとうございました。 -- *java* 2008-01-10 (木) 17:38:04
- こんにちは。いつもこのサイトを参考にさせていただいています。ようやく自分の`java`アプリケーションをリリースしました（[http://www.jdbckit.com](http://www.jdbckit.com)  まだ更新中ですが、）。次回のバージョンアップで、`Special Thanks`をバージョン情報画面に設けて、Terai Atsuhiro様のサイトを感謝対象にさせてよろしいでしょうか？ -- *java* 2008-02-22 (金) 15:13:04
    - こんばんは。どうもです。おお、おめでとうございます。リンクの件はご自由にどうぞ。 -- *aterai* 2008-02-22 (金) 17:00:18
    - 余談: ドキュメントに何か書く必要があるのって、`Apache Software License`でしたっけ？基本的(引用先を強調している`Tips`を除く)に、このサイトの`Tips`は、ちいさなサンプルを目指しているため、コピペしても単独ではあまり役に立たないものが多く、完全に無保証なので、ライセンスなどは気しなくても良いです。 -- *aterai* 2008-02-22 (金) 17:01:08

<!-- dummy comment line for breaking list -->
